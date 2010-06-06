#!/usr/bin/perl

use strict;
use warnings;
use Frontier::Client;

my $HOST = 'ra-sat-vm.ra.rh.com';
my $user = 'admin';
my $pass = '100yard-';
my @newList;
my @test;
my @id;

my $client = new Frontier::Client(url => "http://$HOST/rpc/api");
my $session = $client->call('auth.login', $user, $pass);

print "\nGet All Systems:\n";

my $systems = $client->call('system.listUserSystems', $session);
foreach my $system (@$systems) {
	if(($system->{'name'} =~ m/mrg/) && ($system->{'name'} !~ m/mrgmgr/))  {
	
		print $system->{'name'}."\n";
		my $systemName = $system->{'name'};
		push(@newList,$systemName);
	}
}

print "\nSort Array and Get Oldest\n";

@newList = sort(@newList);

foreach (@newList) {
	print $_ . "\n";
} 

print "\nPrint Last Element\n";
print $newList[-1]."\n";

my $lastsystem = $newList[-1];

print "\nGet Id\n";
my $details = $client->call('system.getId', $session, $lastsystem);
foreach my $detail (@$details) {
	print $detail->{'id'}."\n";
	my $systemId = $detail->{'id'};
	push(@id,$systemId);
}

print "\nPrint ID of last\n";
print $id[-1]."\n";
my $lastid = $id[-1];

print "\nDelete Last ID";
my $delete = $client->call('system.deleteSystems', $session, $lastid);

