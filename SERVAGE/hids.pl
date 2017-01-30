#!/usr/bin/perl
#@AIM : vérifi si un fichier spécifié est modifié et si une demande echou plus de N fois ban de l'ip source
#@AUTHORS : SERVAGE THOMAS
#@PARAMS : None
#@MODIF : None

## modules 

use strict;
use warnings;
 use Getopt::Long;
 use File::Basename;
 
 
 ##initialisation des variables
 
my $Ip ;
my $Cmd ;
 my $count;
my $tempo;
my @Tab=() ; my $o_file=undef; my
$o_help=undef ; use vars qw($o_help $o_file o_nb); sub check_options {
  Getopt::Long::Configure ("bundling");
  GetOptions(
      'h' => \$o_help, 'help' => \$o_help,
      'f=s' => \$o_file, 'file:s' => \$o_file,
	  'o=s' => \$o_nb, 'nombre:s' => \$o_nb,
  );
 }
##Verification des options
  check_options();
	if(!defined $o_nb) {$o_nb=4;}
  if (!defined $o_file) {print " Aucun fichier en parametre \n" ; exit
;}
  if (defined $o_file ) {
        if ( -e $o_file ) {
        print " le fichier $o_file existe \n";
  }
  else {
        print " le fichier $o_file n'existe pas \n";
        exit ;
  }
  }
  if (defined $o_help ) {help();}

 ##Function : Help
 ##@PARAM = NULL
  sub help {
  print "Options \n";
  print "
 -h == Affiche l'aide
 -f == chemin absolu du fichier
 -o == nombre d'authentification avant bannissement 
 "; exit ;
}

##boucle infini
while (1) {
        `inotifywait -e modify $o_file`;
        print " $o_file a été modifié \n";
        if ($o_file =~  /\/var\/log\/auth.log/) {

## si fichier modifié récupération de la ligne modifiée		
                $Cmd=`tail -n1 $o_file`;
                if ($Cmd =~ /authentication failure/) {
                print "une authentification a echouée \n";
                }
                if (($Cmd =~ /Failed password for/) && ($Cmd =~ /ssh/)) {
## Si une tentative de connexion ssh échoue on récupère l'adresse ip source
                        if ( $Cmd =~ /([0-9]{1,3}\.){3}[0-9]{1,3}/){
                        $Ip=$&;
## toutes les IP sources sont récupérées dans un tableau
                        push @Tab, $Ip ;
                        BanIP($Ip) ;
                        }
                }
        }
        else {
		        `tail -n1 $o_file` ;
        }
 }
 ##FUNCTION BanIp
 ##@PARAM : Varchar (IP)
 sub BanIP {
 my ($y) = @_ ;
 $count = 0;
 
## Compte le nombre d'occurence de la dernière adresse IP ayant tenter de se connecter
 foreach my $ligne (@Tab) {
        if ($ligne eq $y) {
                $count=$count + 1 ;
        }

 }
## Si le nombre atteint la limite autorisée ajout d'une règle IPTABLES permannente
 if ($count == $o_nb) {

 `iptables -I INPUT -s $y -j DROP`;
 print " l'adresse ip $y est bannie \n";
 } elsif ($count < $o_nb) {
##Si le nombre de tentative n'est pas atteinte, avertissement
        $tempo= $onb-$count;
        print " plus que $tempo tentative(s) pour $y \n";

 }
 }
 exit 0 ;

