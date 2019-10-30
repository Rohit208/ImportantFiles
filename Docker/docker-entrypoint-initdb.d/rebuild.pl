# #!/usr/bin/perl -w

# #
# # rebuild.pl
# #
# # Developed by Rohit Rehni <rohit@exceleron.com>
# # Copyright (c) 2015 Exceleron Inc
# # Licensed under terms of GNU General Public License.
# # All rights reserved.
# #
# # Changelog:
# # 2015-01-21 - created
# #

# # $Platon$

# use strict;
# use Data::Dumper;
# use FindBin;
# use lib "$FindBin::Bin/../lib";

# my $risk_db_damage = $ENV{PAMS_RISK_DATABASE_DAMAGE} || 0;
# die "Risk to database damage detected (PAMS_RISK_DATABASE_DAMAGE). Aborting " if (!$risk_db_damage);

# #Grab Parameters

# my $shard_id           = shift @ARGV;
# my $load_default_types = shift @ARGV || 0;

# &op_help("You must specify ShardId") if ((not defined($shard_id)) || $shard_id < 0);

# my $cfg         = read_config("DB");

# print "Rebuilding Shard $shard_id on MDM\n";

# my $db_credential = $cfg->{sharding}->{MDM}->{$shard_id};

# unless (defined $db_credential) {
#     print "Config error. Set DB credentials in common config file\n";
#     exit;
# }

# my $port = $db_credential->{'port'};

# my $psql_command = 'psql ';

# if (defined($db_credential->{'service'})) {
#     $psql_command .= " 'service=" . $db_credential->{'service'} . "'";
# }
# else {
#     $psql_command .= " -p $port " if ($port);

#     $psql_command .=
#       " -h " . $db_credential->{'host'} . " " . $db_credential->{'database'} . " " . $db_credential->{'username'};
# }

# $ENV{'PGPASSWORD'} = $db_credential->{'password'};

# my $sql_dir        = "$FindBin::Bin/../sql/MDM";
# my $sql_dir_common = $ENV{PAMS_COMMON_ROOT} . "/sql/Common/";

# my $status = system("$psql_command -c \"select 'Connected' as DB_STATUS \"");

# unless ($status == 0) {
#     die "Shard $shard_id : Unable to connect the database. Invalid credentials. Check PGSERVICE or Config file\n";
# }

# my $root_dir = "$FindBin::Bin/..";

# #CREATE Extensions if not exists
# system($psql_command . " -f $sql_dir/Extensions.sql");

# if ($shard_id == 0) {
#     ## DROP & CREATE SHARD 0 Schema
#     system($psql_command . " -f $sql_dir/Shard_0/01-Schema.sql");

#     # Create partitions for Weather table
#     system("perl $root_dir/script/table_partition.pl $shard_id");
# }
# else {
#     print "Trying to Create Tables and Stored Procedures on Shard $shard_id \n";

#     ## DROP & CREATE COMMON TABLES
#     my $com_sql = $ENV{PAMS_COMMON_ROOT} . "/sql/Common/01-Schema.sql";
#     system($psql_command . " -f $com_sql");

#     ## LOAD Common SP-Functions
#     &psql_load_from_dir($psql_command, $sql_dir_common, "03-SP-Functions", 1);

#     ## DROP & CREATE SHARD M Schema
#     system($psql_command . " -f $sql_dir/Shard_M/01-Schema.sql");

#     ## DROP & CREATE SHARD M Trigger
#     system($psql_command . " -f $sql_dir/Shard_M/01-Trigger.sql");

#     ## LOAD SHARD M Data
#     &psql_load_from_dir($psql_command, $sql_dir, "02-Data");

#     ## LOAD SHARD M SP-Functions
#     &psql_load_from_dir($psql_command, $sql_dir, "03-SP-Functions");

#     ## LOAD SHARD M Views
#     &psql_load_from_dir($psql_command, $sql_dir, "04-Helper-Views");

#     ## LOAD SHARD M Views
#     &psql_load_from_dir($psql_command, $sql_dir, "04-Views");

#     #Setup postgres foreign data wrapper
#     system("perl $root_dir/script/setup_postgres_fdw.pl $shard_id");

#     ## Load SP, Views which are dependent on FDW (Foreign Data Wrapper)

#     ## LOAD SHARD M FDW-SP-Functions
#     &psql_load_from_dir($psql_command, $sql_dir, "05-FDW-SP-Functions");

#     ## LOAD SHARD M FDW-Views
#     &psql_load_from_dir($psql_command, $sql_dir, "06-FDW-Views");

#     if ($load_default_types) {
#         print "Populating AMIType, MeterType data for the utilities in Shard: $shard_id\n";

#         # Create AMIType, MeterType
#         system("perl $root_dir/script/create_settings.pl --shard $shard_id");

#         # Load default data for UsageRate and ChargeType
#         system("perl $root_dir/script/load_default_types.pl $shard_id");
#     }

#     #Load holidays
#     system("perl $root_dir/script/load_holidays.pl $shard_id");

#     # Load Utility DashboardDataStore
#     system("perl $root_dir/script/load_utility_dashboard_data_store.pl --utility ALL --shard $shard_id");
# }

# #psql_load_from_dir
# sub psql_load_from_dir {
#     my $psql_command  = shift;
#     my $sql_dir       = shift;
#     my $dir_name      = shift;
#     my $load_dir_name = shift;

#     my ($sql_dir_full, @files, $sql_file);

#     # If load_dir_name is passed then don't append Shard_M to the dir_name.
#     # Just load dir_name.
#     if ($load_dir_name) {
#         $sql_dir_full = $sql_dir . "$dir_name/";
#     }
#     else {
#         $sql_dir_full = $sql_dir . "/Shard_M/$dir_name/";
#     }

#     opendir(DIR, $sql_dir_full) or die "Could not open $sql_dir_full\n";
#     @files = grep { /\.sql$/ } readdir(DIR);
#     closedir(DIR);

#     foreach (@files) {
#         $sql_file = $sql_dir_full . $_;
#         system($psql_command . " -f $sql_file");
#     }

# }

# ######## Functions ########

# sub read_config
# {   
#     my ($self, $component) = @_;
    
#     #$components any one of MDM ,Alerts, WWW ,Dispatcher, DB
    
#     # Use cached configuration if it is available
#     if (defined $component and defined $self->{cached_config}) {
#         if (defined $self->{cached_config}->{$component}) {
#             return $self->{cached_config}->{$component};
#         }
#     }
#     elsif ((not defined $component) and defined $self->{cached_config}) {
#         if (defined $self->{cached_config}->{DB} and defined $self->{cached_config}->{Projects}) {
#             return $self->{cached_config};
#         }
#     }
    
#     my $main_config = $self->get_main_config();
    
#     my @files      = ();
#     my @components = ();
#     unless (defined $component) {
        
#         #no component is specifed return all conf info across all the projects
        
#         foreach my $project (keys %{$main_config->{Projects}}) {
#             my $conf_dir = $self->get_conf_dir($project);
#             my $file = catfile($conf_dir, 'main.pl');
#             push(@files,      $file);
#             push(@components, $project);
#         }
#     }
#     else {
#         #read conf for the given component
#         my $conf_dir = $self->get_conf_dir($component);
#         my $file = catfile($conf_dir, 'main.pl');
#         push(@files,      $file);
#         push(@components, $component);
#     }
    
#     my $config = Config::Any->load_files(
#         {   
#             files   => \@files,
#             use_ext => 1,
#         }
#     );
    
#     my $i = 0; 
#     foreach my $confs (@{$config}) {
#         $self->{cached_config}->{$components[$i]} = $confs->{$files[$i]};
#         $i++;
#     }
    
#     return defined $component ? $self->{cached_config}->{$component} : $self->{cached_config};
# }

# #show help
# sub op_help {
#     my $msg = shift;

#     if ($msg) {
#         print "$msg\n\n";
#     }

#     print <<EOF;
# rebuild.pl - Rebuild DB for each Shard 

# Usage:
# 	rebuild.pl [ShardId]

# 	ShardId:
# 	Id of Shard Specified in pams_www.pl 
# EOF
#     exit;
# }


# # vim: ts=4
# # vim600: fdm=marker fdl=0 fdc=3




