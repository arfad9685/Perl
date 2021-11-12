sub at0018 {

&koneksi_ast2;
genfuncast::view_header($in{ss}, $s3s[2], 'Ekstrak Excel Inv');
genfuncast::validasi_akses($s3s[11], $in{ss},'S');

#use strict;
#use warnings;
use Spreadsheet::ParseExcel;
use Date::Calc qw(Add_Delta_Days);
use Date::Calc qw(Day_of_Week);

($month,$day,$year,$weekday) = &jdate(&today());
          $month = substr "0$month",-2;
          $day = substr "0$day",-2;
$today = $month.'/'.$day.'/'.$year;
$ymd_today =   $year.'-'.$month.'-'.$day;
#($month,$day,$year,$weekday) = &jdate(&tambahhari(-1));
#          $month = substr "0$month",-2;
#          $day = substr "0$day",-2;
#$ymd_kemarin = $year.'-'.$month.'-'.$day;
#$hari1 = $weekday;
#if (length($month)<2) {
#  $thnbln='0'.$month;
#} else {
#  $thnbln=$month;
#}

#$t='0'.$month;


print qq~
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=center> <h2 class="hurufcol"> EKSTRAK EXCEL INVENTORI</h2> </td>
     </tr>
     </table>

<FORM ACTION="/cgi-bin/sisasset.cgi" METHOD="post" ENCTYPE="multipart/form-data">
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at0018>
  <input type=hidden name=id value=$in{id}>
<table class=hurufcol width=500>
  <tr bgcolor=$colcolor>
  <td width=300>Select File to Upload </td><td><input type=file name="fileup" class=hurufcol></td>
  </tr>

~;
print qq~
  </table>
  <input type=submit value='Upload' name="upload" class="huruf1">
  </form>~;

$q = $dba1->prepare("SELECT KODE,JENIS,MEREK,TIPE,UKURAN,KONDISI,KETERANGAN,NOSERI,IP,CURRCABANG,CURRIDLAMA,KODELAMA,OS,COMPUTERNAME, OPRCREATE from inventori where jenis <> '' ");
$q->execute();
$i=0;
while (@rec= $q->fetchrow_array())
{  $kode[$i] = $rec[0];
   $jenis[$i] = $rec[1];
   $i++;
}

if ($in{upload} && $in{fileup}) {

   $FileName="/home/sisasset/htdocs/tmpast/AssetKST23".$year.$month.$day.".xls";
   rename("$in{fileup}", "/home/sisasset/htdocs/tmpast/AssetKST23".$year.$month.$day.".xls");
   $foldertempat="/home/sisasset/htdocs/tmpast/AssetKST23".$year.$month.$day.".xls";
   chmod(0666, "/home/sisasset/htdocs/tmpast/AssetKST23".$year.$month.$day.".xls");

my $parser   = Spreadsheet::ParseExcel->new();
my $workbook = $parser->parse($FileName);
die $parser->error(), ".\n" if ( !defined $workbook );

$no=1;
   for my $worksheet ( $workbook->worksheets() ) {

        my ( $row_min, $row_max ) = $worksheet->row_range();
        my ( $col_min, $col_max ) = $worksheet->col_range();
        $b=3;
        print " rowmax=".$row_max ;
#        $row_max=10;
        for my $row ( $b .. $row_max ) {
            print qq~row=$row <br/> ~;
                if ($worksheet->get_cell( $row, 11 )->value()) { $jenis = $worksheet->get_cell( $row, 11 )->value();}
                else {$jenis = ""; }
                        $jenis =~ s/^\s+|\s+$//g;
                if ($worksheet->get_cell( $row, 12 )->value()) {$merek = $worksheet->get_cell( $row, 12 )->value();}
                else {$merek = "";}
                if ($worksheet->get_cell( $row, 13)) {$tipe = $worksheet->get_cell( $row, 13)->value();}
                else {$tipe = "";}
                if ($worksheet->get_cell( $row, 14 )) {$ukuran = $worksheet->get_cell( $row, 14 )->value();}
                else {$ukuran = "";}
                if ($worksheet->get_cell( $row, 16 )->value()) {$kodelama = $worksheet->get_cell( $row, 16 )->value();}
                else {$kodelama = "";}
                if ($worksheet->get_cell( $row, 17 )) {$noseri = $worksheet->get_cell( $row, 17 )->value();}
                else {$noseri = "";}
                if ($worksheet->get_cell( $row, 18)->value()) {$kondisi= $worksheet->get_cell( $row, 18)->value();}
                else {$kondisi = "";}
                if ($worksheet->get_cell( $row, 5 )) {$IP = $worksheet->get_cell( $row, 5 )->value();}
                else {$IP = "";}
                $idlama= $worksheet->get_cell( $row, 6 )->value();
                $cabang = $worksheet->get_cell( $row, 7 )->value();
                if ($worksheet->get_cell( $row, 8 )) {$os = $worksheet->get_cell( $row, 8 )->value();}
                else {$os="";}
                if ($worksheet->get_cell( $row, 2 )) {$computername = $worksheet->get_cell( $row, 2 )->value();}
                else {$computername = "";}
                if ($worksheet->get_cell( $row, 1 )) {$keterangan= $worksheet->get_cell( $row, 1 )->value();}
                else {$keterangan= "";}

        print qq~ $jenis $merek $tipe $ukuran $kodelama $noseri $kondisi $IP $idlama $cabang $os $computername $keterangan<br/> ~;

$query = $dba1->prepare("select counter from jenisinv where jenis='$jenis' ");
$query->execute();
@row = $query->fetchrow_array();
$ctr = $row[0]+1;
        if($ctr>=1000){  }
        elsif($ctr>=100){ $ctr="0".$ctr; }
        elsif($ctr>=10){ $ctr="00".$ctr; }
        else { $ctr="000".$ctr; }
        $kode = $jenis.$ctr;
        
$subkolom="", $subvalue="";
if ($tipe) {$subkolom.=",TIPE";  $subvalue.=",'$tipe'"; }
if ($ukuran) {$subkolom.=",UKURAN";  $subvalue.=",'$ukuran'";}


print("INSERT INTO INVENTORI (KODE,JENIS,MEREK,KONDISI,KETERANGAN,FLAGASSET,NOSERI,IP,CURRCABANG,CURRIDLAMA,KODELAMA,OS,COMPUTERNAME, OPRCREATE $subkolom) VALUES
            ('$kode', '$jenis', '$merek', '$kondisi','$keterangan','N','$noseri', '$IP','$cabang', '$idlama','$kodelama','$os','$computername','$s3s[0]' $subvalue);");


 $q1 = $dba1->do("INSERT INTO INVENTORI (KODE,JENIS,MEREK,KONDISI,KETERANGAN,FLAGASSET,NOSERI,IP,CURRCABANG,CURRIDLAMA,KODELAMA,OS,COMPUTERNAME, OPRCREATE $subkolom) VALUES
            ('$kode', '$jenis', '$merek', '$kondisi','$keterangan','N','$noseri', '$IP','$cabang', '$idlama','$kodelama','$os','$computername','$s3s[0]' $subvalue);");

if ($q1!=0)
{$q2 = $dba1->do("update jenisinv set counter=counter+1 where jenis='$jenis';");}
else { print qq~<div class=warning_not_ok>Gagal INSERT INVENTORI : INSERT INTO INVENTORI (KODE,JENIS,MEREK,KONDISI,KETERANGAN,FLAGASSET,NOSERI,IP,CURRCABANG,CURRIDLAMA,KODELAMA,OS,COMPUTERNAME, OPRCREATE $subkolom) VALUES
            ('$kode', '$jenis', '$merek', '$kondisi','$keterangan','N','$noseri', '$IP','$cabang', '$idlama','$kodelama','$os','$computername','$s3s[0]' $subvalue);</div>~; }

#                for ($i=1; $i<=7; $i++)
#                { if ($worksheet->get_cell( $row, $i+5 )->value())
#                  {
#                        $kds[$i] = $worksheet->get_cell( $row, $i+5 )->value();
#                         print qq~$kds[$i] <br/> ~;
#                   }
#                }

               }# end for row
        }  #end for worksheet
} #end if



print qq~
    <hr width=100>
</center>
~;

}

sub getIndexOfShift {
    ($find, @arr) = @_;

    for ($z=0; $z<@arr; $z++)
    {  $idx = index($arr[$z], $find);
       if ($idx>=0) { return $z; }
    }

    return -1;
}
;
1
