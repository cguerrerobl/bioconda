#!/usr/bin/env perl

my @items = (
    ["Bio::Tools::Run::Bowtie", '1.007002'],
    ["Bio::Tools::Run::BWA", '1.007002'],
    ["Bio::Tools::Run::EMBOSSApplication", '1.007002'],
    ["Bio::Tools::Run::Hmmer", '1.007002'],
    ["Bio::Tools::Run::Samtools", '1.007002'],
    ["Bio::Tools::Run::StandAloneBlastPlus", '1.007002'],
);

foreach $item (@items) {
    my ($module, $expected_version) = @$item;
    print "Checking '$module' version: ";
    my $actual_version = eval "use $module; $module->VERSION";
    if($@) { die $@; }
    if(defined $actual_version) {
        print $actual_version;
        if($actual_version == $expected_version) {
            print " $actual_version (PASSED)\n";
        }
        else {
            print " $actual_version (FAILED)\n";
            die("$module: Expected version '$expected_version', " .
                "but found '$actual_version'.")
        }
    }
    elsif(defined $expected_version) {
        print "<not available> (FAILED)\n";
        die("$module: Expected version '$expected_version', " .
            "but found none");
    }
    else {
        print "<not checked> (PASSED)\n";
    }
}
