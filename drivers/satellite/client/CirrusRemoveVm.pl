#!/usr/bin/perl

use strict;
use warnings;
use Frontier::Client;

#my $HOST = '';
#my $user = '';
#my $pass = '';
my $HOST = 'ra-sat-vm.ra.rh.com';
my $user = 'admin';
my $pass = '100yard-';
my @newList;
my @test;
my @id;

my $client = new Frontier::Client(url => "http://$HOST/rpc/api");
my $session = $client->call('auth.login', $user, $pass);

my $lastsystem = $newList[-1];

#print "\nGet Id\n";
my $details = $client->call('system.getId', $session, $ARGV[0]);
foreach my $detail (@$details) {
	print $detail->{'id'}."\n";
	my $systemId = $detail->{'id'};
	push(@id,$systemId);
}

#print "\nPrint ID of last\n";
#print $id[-1]."\n";
my $lastid = $id[-1];

#print "\nDelete Last ID";
my $delete = $client->call('system.deleteSystems', $session, $lastid);

