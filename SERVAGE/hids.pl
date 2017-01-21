#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use File::Basename;

my $Ip ;
my $Cmd ;
my $count;
my $tempo;
my $o_file=undef;
my $o_help=undef ;
use vars qw($o_help $o_file);
sub check_options {
  Getopt::Long::Configure ("bundling");
  GetOptions(
      'h'     => \$o_help,        'help'          => \$o_help,
      'f=s'   => \$o_file,        'file:s'	  => \$o_file,    
  );
 } 
 
  check_options();
  
  if (!defined $o_file) {print " Aucun fichier en parametre \n" ; exit ;}
  if (defined $o_file ) {
	if ( -e $o_file )  {
	print " le fichier $o_file existe \n"; 
  }
  else {
	print " le fichier $o_file n'existe pas \n";
	exit ; 
  }
  }
  if (defined $o_help ) {help();} 
  
  sub help {
  print "Options \n";
  print "
 -h  == Affiche l'aide 
 -f  == chemin absolu du fichier 
 ";
exit ; 
}


while (1) {
	`inotifywait -e modify $o_file`;
	print " $o_file a été modifié \n"; 
	if ($o_file =~	/\/var\/log\/auth.log/) {
 
		$Cmd=`tail -n1 $o_file`;
		if ($Cmd =~ /authentication failure/) {
		print "une authentification a echouée \n";		
		}
		if (($Cmd =~ /Failed password for/) && ($Cmd =~ /ssh/)) {
			
			if ( $Cmd =~ /([0-9]{1,3}\.){3}[0-9]{1,3}/) {
			$Ip = $1;
			$count ++;
			banIP($count, $Ip) ; 
			}
		}
	}
 }
 sub BanIP {
 my ($x, $y) = @_ ;
 if ($x == 4) {
 
 `iptables -I INPUT -s $y -j DROP`;
 print " l'adresse ip $y est bannie \n"; 
 } elsif ($x < 4) {
 
	$tempo= 4-$x;
	print " plus que $tempo tentative(s) \n"; 
 
 }
 }
 exit 0 ; 