#! /usr/bin/perl
# Contact Dr Tushar Ranjan Moharana (author) at tusharranjanmoharana@gmail.com for any query and/or bug
use strict; use warnings; 
use Algorithm::Combinatorics qw(combinations);
my @temp1; my @temp2; my @comb; my @temp; my @read; my @worthy; my %pharmphor; my $comma=0; my $ID=0; my $line; my $worthy; my $B=0; my $H=0; my $S=0; my $C=0; my $N=0; my $O=0; my $countH=0; my $countS=0; my $countC=0; my $countN=0; my $countO=0; my $temp; my $prev; my $num;
print "hellow";
open (READ, "$ARGV[0]\.pdb");
while (<READ>)
{
$temp=$_;
@read=split; 
unless ($read[0] eq "HETATM"){
	next;
	}
if ($read[2] eq "B"){
$B++;
$pharmphor{"B$B"}=$temp;
}
if ($read[2] eq "H"){
$H++;
$pharmphor{"H$H"}=$temp;
}
if ($read[2] eq "S"){
$S++;
$pharmphor{"S$S"}=$temp;
}
if ($read[2] eq "C"){
$C++;
$pharmphor{"C$C"}=$temp;
}
if ($read[2] eq "N"){
$N++;
$pharmphor{"N$N"}=$temp;
}
if ($read[2] eq "O"){
$O++;
$pharmphor{"O$O"}=$temp;
}
if ($read[2] eq "F"){
@temp1=split(' ', $prev);
if ($temp1[2] eq "O"){
$pharmphor{"FO$O"}=$temp;
@temp2=split(' ', $temp);
$pharmphor{"CFO$O"}="$temp2[5],$temp2[6],$temp2[7]";
}
if ($temp1[2] eq "N"){
$pharmphor{"FN$N"}=$temp;
@temp2=split(' ', $temp);
$pharmphor{"CFN$N"}="$temp2[5],$temp2[6],$temp2[7]";
}
}
$prev=$temp;
}
close READ;
print "hellow1";
#proble start after this
@temp=keys %pharmphor;
@temp = grep !/F/, @temp;
@temp = grep !/B/, @temp;
my $iter = combinations(\@temp, 15);
while (my $com = $iter->next) {
@comb=@$com;
$countH= grep (/H/, @comb);
$countS= grep (/S/, @comb);
$countC= grep (/C/, @comb);
$countN= grep (/N/, @comb);
$countO= grep (/O/, @comb);
			$num=join('_', @comb);
		push (@worthy, $num);
}
foreach my $i (@worthy){
	print "$i\n";
	$ID++;
	open (WRITE, ">$ARGV[0]\_$ID\_$i\.query");
	print WRITE "{
    \"points\": [
        ";
        $comma=0;
        my @ev=grep (/B/, keys%pharmphor);
        foreach my $k (@ev){
			@temp=split(' ', $pharmphor{$k});
			if ($comma==1){
				print WRITE ",";
			}
			print WRITE "
        {
            \"name\": \"ExclusionSphere\",
            \"radius\": 1,
            \"requirement\": \"required\",
            \"size\": 0,
            \"x\": $temp[5],
            \"y\": $temp[6],
            \"z\": $temp[7],
            \"enabled\": true,
            \"svector\": null,
            \"minsize\": \"\",
            \"maxsize\": \"\"
        }";
			$comma=1;
		}
	@comb=split('_', $i);
	foreach my $j (@comb)
{
@temp=split(' ', $pharmphor{$j});
if ($temp[2] eq "N")
{
print WRITE ",
        {
            \"name\": \"HydrogenDonor\",
            \"radius\": 0.5,
            \"requirement\": \"required\",
            \"size\": 0,
            \"x\": $temp[5],
            \"y\": $temp[6],
            \"z\": $temp[7],
            \"enabled\": true,
            \"minsize\": \"\",
            \"maxsize\": \"\",
            \"svector\": {
                \"x\": 1,
                \"y\": 0,
                \"z\": 0
            },
            \"vector_on\": 0
        }";
}
if ($temp[2] eq "O")
{
print WRITE ",
        {
            \"name\": \"HydrogenAcceptor\",
            \"radius\": 0.5,
            \"requirement\": \"required\",
            \"size\": 0,
            \"x\": $temp[5],
            \"y\": $temp[6],
            \"z\": $temp[7],
            \"enabled\": true,
            \"minsize\": \"\",
            \"maxsize\": \"\",
            \"svector\": {
                \"x\": 1,
                \"y\": 0,
                \"z\": 0
            },
            \"vector_on\": 0
        }";
}
if ($temp[2] eq "C")
{
print WRITE ",
        {
            \"name\": \"Hydrophobic\",
            \"radius\": 0.5,
            \"requirement\": \"required\",
            \"size\": 0,
            \"x\": $temp[5],
            \"y\": $temp[6],
            \"z\": $temp[7],
            \"enabled\": true,
            \"minsize\": \"\",
            \"maxsize\": \"\",
            \"svector\": null,
            \"vector_on\": 0
        }";
}
if ($temp[2] eq "H")
{
print WRITE ",
        {
            \"name\": \"PositiveIon\",
            \"radius\": 0.75,
            \"requirement\": \"required\",
            \"size\": 0,
            \"x\": $temp[5],
            \"y\": $temp[6],
            \"z\": $temp[7],
            \"enabled\": true
        }";
}
if ($temp[2] eq "S")
{
print WRITE ",
        {
            \"name\": \"NegativeIon\",
            \"radius\": 1,
            \"requirement\": \"required\",
            \"size\": 0,
            \"x\": $temp[5],
            \"y\": $temp[6],
            \"z\": $temp[7],
            \"enabled\": true,
            \"svector\": null,
            \"minsize\": \"\",
            \"maxsize\": \"\"
        }";
}
}
print WRITE "
    ],
    \"receptor\": \"\",
    \"recname\": \"\",
    \"subset\": \"purchasable\",
    \"max-orient\": \"\",
    \"reduceConfs\": \"\",
    \"max-hits\": \"\",
    \"maxRMSD\": \"\",
    \"minMolWeight\": \"\",
    \"maxMolWeight\": \"\",
    \"minrotbonds\": \"\",
    \"maxrotbonds\": \"\",
    \"residuevisible\": true,
    \"residuestyle\": \"sticks\",
    \"residuecolor\": \"rasmol\",
    \"color-picker-buttonresidue-color-container-button\": \"\",
    \"current-colorresidue-color-container\": \"#FFFFFF\",
    \"receptorresvisible\": true,
    \"receptorresstyle\": \"sticks\",
    \"receptorrescolor\": \"rasmol\",
    \"color-picker-buttonreceptorres-color-container-button\": \"\",
    \"current-colorreceptorres-color-container\": \"#FFFFFF\",
    \"resultsvisible\": true,
    \"resultsstyle\": \"sticks\",
    \"resultscolor\": \"rasmol\",
    \"color-picker-buttonresults-color-container-button\": \"\",
    \"current-colorresults-color-container\": \"#FFFFFF\",
    \"queryvisible\": true,
    \"receptorsurfstyle\": \" sasurface 0.0\",
    \"receptorsurfcolor\": \"partialcharge\",
    \"color-picker-buttonreceptorsurf-color-container-button\": \"\",
    \"current-colorreceptorsurf-color-container\": \"#FFFFFF\",
    \"jmolMoveTo\": \"moveto 0.0 { 800 384 -461 16.72} 57.18 0.0 0.0 {3.582142857142857 -3.1779714285714284 -0.10614285714285712} 6.739834668954489 {0 0 0} 0 0 0 3.0 0.0 0.0;\",
    \"sdf\": \"\"
}";
close WRITE;
print "$num\n";
}
