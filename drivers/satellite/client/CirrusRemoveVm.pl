#!/usr/bin/perl

#use strict;
#use warnings;
use Frontier::Client;

#my $HOST = '';
#my $user = '';
#my $pass = '';
my $HOST = 'ra-sat-vm.ra.rh.com';
my $user = 'tenant';
my $pass = '100yard-';
my @newList;
my $system = $ARGV[0];

my $client = new Frontier::Client(url => "http://$HOST/rpc/api");
my $session = $client->call('auth.login', $user, $pass);

my $systems = $client->call('system.listUserSystems', $session);
#foreach my $system (@$systems) {
#		print $system->{'name'}."\n";
#}


my $details = $client->call('system.getId', $session, $system);
foreach my $details (@$details) {
#	print $details->{'id'}."\n";
	my $id = $details->{'id'};
	my $delete = $client->call('system.deleteSystems', $session, $id);
}

#log out, it's polite
$client->call('auth.logout', $session);
