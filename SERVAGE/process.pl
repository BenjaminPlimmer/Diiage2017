#!/usr/bin/perl
use warnings;
use strict;
use IO::Dir;
no warnings 'recursion';
no warnings 'uninitialized';
##Création du fichier temporaire
`touch /tmp/liste.csv`;


sub GetFilesList
{
        my $Path = $_[0];
        my $FileFound;
        my @FilesList=();
        my $i=0;
        # Lecture de la liste des fichiers
        opendir (my $FhRep, $Path)
                or die "Impossible d'ouvrir le repertoire $Path\n";
        my @Contenu = grep {/[0-9]/} readdir($FhRep);
        closedir ($FhRep);
        foreach $FileFound (@Contenu) {
                if( defined($FileFound) ) {
                        $FilesList[$i]=$FileFound;
                        $i++;
                }
        }
        return @FilesList;
}
my @Files = GetFilesList ("/proc/"); sub GetInfo {
        my @TabName;
        my @TabPpid;

        my @TabPid;
        my $Name;
        my $Pid;
        my $Ppid;
        my $Path;
        my $FileName2='/tmp/liste.csv';
        my $VarLigne;
        foreach my $File (@_) {
                $Path="/proc/$File/status";
#               print "$Path\n";
                open FILE, '<', $Path;
                my @Contenu = <FILE>;
                foreach my $Line (@Contenu) {
                        if ( $Line =~ /^Name/ ) {
                                @TabName=split(/:/,$Line);
                                $TabName[1]=~ s/^\s+//;
                                $TabName[1]=~ s/\n//g;
                                $Name= $TabName[1];

                        }
                        if ( $Line =~ /^Pid/ ) {
                                @TabPid=split(/:/,$Line);
                                $TabPid[1]=~ s/^\s+//;
                                $TabPid[1]=~ s/\n//g;
                                $Pid= $TabPid[1];
                        }
                        if ( $Line =~ /^PPid/ ) {
                                @TabPpid=split(/:/,$Line);
                                $TabPpid[1]=~ s/^\s+//;
                                $TabPpid[1]=~ s/\n//g;
                                $Ppid= $TabPpid[1];
                        }
                }
                close(FILE);
                $VarLigne="$Name;$Pid;$Ppid";
                open my $fh, '>>',$FileName2;
                print {$fh} "$VarLigne \n";
                close $fh;
        }
}
GetInfo (@Files);
print "systemd\n";
open FILE2, '<', '/tmp/liste.csv';
my @Contenu2 = <FILE2>;
        my $CurrentLevel=0;


sub subtree {
        my $Process;
        my $Child;
        my $Parent;
        my @Tab;
                foreach my $Line2 (@Contenu2) {
                        @Tab=split(/;/,$Line2);
                        $Process=$Tab[0];
                        #$Process=~ s/\n//g;
                        $Child=$Tab[1];
                        #$Child=~ s/\n//g;
                        $Parent=$Tab[2];
                        #$Parent=~ s/\n//g;
                        if ( $Parent =~ @_) {
                                for (my $i=1; $i < $CurrentLevel; $i++) {
                                print "      ";
                                }
                        print " └----- $Process($Child) \n";
                        $CurrentLevel++;
                        subtree ($Child);
                        $CurrentLevel--;
                        }
                }
}
        close(FILE2);

subtree (1);
print "Rentrez le PID pour supprimer le processus : \n";
my $Saisie = <STDIN>;

`kill $Saisie` ;

print "le processus avec comme PID $Saisie est tué \n";




##Supression fichier temporaire
`rm /tmp/liste.csv`;

exit 0






						
