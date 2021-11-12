sub kop021 {

use Spreadsheet::WriteExcel;
genfunckop::view_header_kop($in{ss}, $s3s[2], 'Pinjaman', $s3s[17]);
genfunckop::validasi_akses_kop($s3s[11], $in{ss});
&koneksi_kop2;
$dbk3 = DBI->connect("dbi:Firebird:db=/daten/koperasi.fdb;ib_dialect=3;", "sisadmin", "datos18");
$bgbunga2 = "#c9f7ad";
$bgbunga = "#bfe8a7";
$bgbungadark = "#a9e884";
@aktif = ("Y", "N");
if(!$in{vaktif}){ $in{vaktif}="Y"; }

@yesno = ("N","Y");
#if(!$in{lunas}){ $in{lunas}="N"; }
($month,$day,$year,$aweekday) = &jdate(&today());
$month = substr "0$month",-2;
$day = substr "0$day",-2;
if(!$in{tahun}){ $in{tahun}=$year; }
#if(!$in{cabang}){ $in{cabang}='HRD_ALL'; }
print qq~
<style type="text/css">
\@import url("/jscalendar/calendar-blue.css");
   .hoverTable tr{
		background: #ffffff;
	}
    .hoverTable tr:hover {
          background-color: #ffff99;
    }
    .hoverTable td:hover {
          border: 2px solid red;
    }
</style>
<script type="text/javascript" src="/jscalendar/calendar.js"></script>
<script type="text/javascript" src="/jscalendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="/jscalendar/calendar-setup.js"></script>

<script type='text/javascript' src='/jquery.min.js'></script>
<script type='text/javascript' src="/jquery.chained.js"></script>
<link rel="stylesheet" href="/colorbox.css" />
<script type="text/javascript" src="/jquery.colorbox.js"></script>

<script type="text/javascript">
\$(document).ready(function(){
   \$(".iframe").colorbox({
      iframe:true,
      width:"1000px",
      height:"95%"});

    \$("#click").click(function(){
	 \$(".iframe").colorbox.close();
    });
});
</script>

     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=120>
     <form method=post action="/cgi-bin/siskop.cgi" >
      <input type="submit" name="back" value="Daftar Pinjaman" class="huruf1"/>
      <input name="pages" type="hidden" value=kop021a>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
     </td>
     <td align=center> <h2 class="hurufcol"> PINJAMAN</h2> </td>
     <td align=left width=120>
     ~;
if ($s3s[11] eq 'S')
{     print qq~
      <a class='iframe' href='/cgi-bin/kopbox.cgi?display=kop021c&ss=$in{ss}'><img src='/images/add.png'></a>
      <a class='iframe' href='/cgi-bin/kopbox.cgi?display=kop021d&ss=$in{ss}' class='hurufcol'><img src='/images/lunas.png'></a>
       ~;
}     print qq~</td>
     </tr>
     </table>

<form action="/cgi-bin/siskop.cgi" method="post" name='vq'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=kop021>
<table>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp; Tahun </td>
    <td class="hurufcol" ><select name="tahun" class="huruf1" id="tahun">
    ~;
($month,$day,$year,$weekday) = &jdate(&today());
for ($i=2017; $i<=$year+1; $i++)
{  $selected="";
   if ($in{tahun}==$i) { $selected="selected"; }
   print qq~<option value='$i' $selected> $i </option>~;
}
print qq~
    </select>
    </td>
    <td class="hurufcol"> &nbsp; Cabang </td>
    <td class="hurufcol" ><select name="cabang" class="huruf1" id="cabang">
    <option value=''>ALL</option>~;
$query = $dbk->prepare("select distinct kodecabang, namastore from anggota a, getkry k
where a.idlama=k.idlama order by kodecabang");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $selected="";
   if ($in{cabang} eq $rec[0]) { $selected="selected"; }
   print qq~<option value='$rec[0]' $selected> $rec[0] - $rec[1] </option>~;
}
print qq~
    </select>
    </td>
    <td class="hurufcol"> &nbsp; Lunas </td>
    <td class="hurufcol" ><select name="lunas" class="huruf1" id="lunas">
    <option value=''>ALL</option>~;
for ($i=0; $i<@yesno; $i++)
{  $selected="";
   if ($in{lunas} eq $yesno[$i]) { $selected="selected"; }
   print qq~<option value='$yesno[$i]' $selected> $yesno[$i] </option>~;
}
print qq~
    </select>
    </td>
<!--  <td class="hurufcol" > &nbsp; Aktif </td>
    <td class="hurufcol" ><select name="vaktif" class="huruf1" id="vaktif">
    ~;
for ($i=0; $i<@aktif; $i++)
{  $selected="";
   if ($in{vaktif} eq $aktif[$i]) { $selected="selected"; }
   print qq~<option value='$aktif[$i]' $selected> $aktif[$i] </option>~;
}
print qq~
    </select>
    </td>-->
    <td><input type='submit' name='view' value='Go'>~;
  print qq~<input type='submit' name='export' value='Export'>~;
print qq~ </td>
  </tr>
</table>
</form>    ~;

if($in{export})
{
  @kolom = ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'AA', 'AB', 'AC', 'AD', 'AE', 'AF', 'AG', 'AH', 'AI', 'AJ', 'AK', 'AL', 'AM', 'AN', 'AO', 'AP', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AV', 'AW', 'AX', 'AY', 'AZ', 'BA', 'BB', 'BC', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BK', 'BL', 'BM', 'BN', 'BO', 'BP', 'BQ', 'BR', 'BS', 'BT', 'BU', 'BV', 'BW', 'BX', 'BY', 'BZ', 'CA', 'CB', 'CC', 'CD', 'CE', 'CF', 'CG', 'CH', 'CI', 'CJ', 'CK', 'CL', 'CM', 'CN', 'CO', 'CP', 'CQ', 'CR', 'CS', 'CT', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DA', 'DB', 'DC', 'DD', 'DE', 'DF', 'DG', 'DH', 'DI', 'DJ', 'DK', 'DL', 'DM', 'DN', 'DO', 'DP', 'DQ', 'DR');
  $temp01="/home/$folder_user/htdocs/tmpkop/Pinjaman_$in{tahun}_".$year.$month.$day.".xls";
  $temp02="Pinjaman_$in{tahun}_".$year.$month.$day.'.xls';

  my $workbook  = Spreadsheet::WriteExcel->new($temp01);
  my $worksheet = $workbook->add_worksheet();

  my $bold = $workbook->addformat();
  $bold->set_bold();
  $bold->set_size('11');
  my $mboldcenter = $workbook->addformat();
  $mboldcenter->set_align('center');
  $mboldcenter->set_bold();
  $mboldcenter->set_size('11');
  $mboldcenter->set_text_wrap();
  my $boldcenter = $workbook->addformat();
  $boldcenter->set_align('center');
  $boldcenter->set_bold();
  $boldcenter->set_size('11');
  my $grey = $workbook->addformat();
  $grey->set_bg_color('cyan');
  my $boldr = $workbook->addformat();
  $boldr->set_align('right');
  $boldr->set_bold();
  $boldr->set_size('11');
  my $boldrgrey = $workbook->addformat();
  $boldrgrey->set_align('right');
  $boldrgrey->set_bold();
  $boldrgrey->set_size('11');
  $boldrgrey->set_bg_color('cyan');
  my $orange = $workbook->addformat();
  $orange->set_bg_color('orange');
  my $yellow = $workbook->addformat();
  $yellow->set_bg_color('yellow');
  my $magenta = $workbook->addformat();
  $magenta->set_bg_color('magenta');

  $worksheet->set_column(0, 0, 3);
  $worksheet->set_column(1, 1, 10);
  $worksheet->set_column(2, 2, 30);
  $worksheet->set_column(3, 4, 7);
  $worksheet->set_column(5, 5, 10);
  $worksheet->set_column(6, 41, 8);
  $worksheet->set_column(42, 44, 11);

  $worksheet->merge_range("A1:A2", "No.", $mboldcenter);
  $worksheet->merge_range("B1:B2", "NIK", $mboldcenter);
  $worksheet->merge_range("C1:C2", "Nama Peminjam", $mboldcenter);
  $worksheet->merge_range("D1:D2", "Mulai Cicil", $mboldcenter);
  $worksheet->merge_range("E1:E2", "Masa Cicil", $mboldcenter);
  $worksheet->merge_range("F1:F2", "Jumlah Pinjaman", $mboldcenter);
  for ($i=1, $f=6, $g=8; $i<=12; $i++, $f+=3, $g+=3)
  { $bulan = genfuncpyl::format_bulan2($i);
    $bulan = substr $bulan,0,3;
    $worksheet->merge_range("$kolom[$f]1:$kolom[$g]1", $bulan, $mboldcenter);
    $worksheet->write(1, $f,  "A",$boldcenter);
    $worksheet->write(1, $f+1,"B",$boldcenter);
    $worksheet->write(1, $g,  "D",$boldcenter);
  }
  $worksheet->merge_range("AQ1:AQ2", "Total Angsuran", $mboldcenter);
  $worksheet->merge_range("AR1:AR2", "Total Bunga", $mboldcenter);
  $worksheet->merge_range("AS1:AS2", "Total Denda", $mboldcenter);
  $worksheet->merge_range("AT1:AT2", "Sisa Pinjaman", $mboldcenter);

  $subq="";
  if ($in{cabang}) { $subq=" AND kodecabang='$in{cabang}' "; }
  if ($in{lunas}) { $subq=" AND lunas='$in{lunas}' "; }
  if ($in{vaktif}) { $subq=" AND a.aktif='$in{vaktif}' "; }

  $q = $dbk->prepare("select nik, nlengkap, p.idlama, kodecabang, jmlapprove/1000, masacicil, dtapprove, p.recid, lunas
from pinjaman p, getkry k, anggota a
where p.idlama=k.idlama and p.idlama=a.idlama $subq
 order by dtapprove, jmlapprove");
  $q->execute();
  $no=1; $baris=2;
  $tmpcab='';  $totala=0; $totalb=0; $totalpinjam=0;  $totalsisapinj=0;
  while (@row = $q->fetchrow_array())
  {
#  if ($tmpcab and $tmpcab ne $row[3]) { print qq~<tr bgcolor=$dark height=5><td colspan=7></td> </tr>~; }
    $dtstart = genfuncpyl::mdytodmy($row[6]);
    $dtstart = substr $dtstart,0,5;

    $formatbaris="";
    if($row[8] eq 'Y'){ $formatbaris=$magenta;  }
    $worksheet->write($baris, 0,  "$no.",$formatbaris);
    $worksheet->write($baris, 1,  "$row[0]",$formatbaris);
    $worksheet->write($baris, 2,  "$row[1]",$formatbaris);
    $worksheet->write($baris, 3,  "$dtstart",$formatbaris);
    $worksheet->write($baris, 4,  "$row[5]",$formatbaris);
    $worksheet->write($baris, 5,  "$row[4]",$formatbaris);
    $q2 = $dbk2->prepare("select hrsbayar, bunga, periode, jmlbayar, denda from angsuran  where pinjaman_id = $row[7] and periode like '$in{tahun}%' and batal='N'
        order by periode");
    $q2->execute();   $kolom=6;
    $totalang=0; $totalbunga=0; $ctrb=1;  $totalangbyr=0;
    while (@row2 = $q2->fetchrow_array())
    {  $b = substr $row2[2],5,2;   $b = $b-0;
       if($ctrb!=$b)
       { for ($i=$ctrb; $i<=($b-1); $i++){ $kolom+=3; }
         $ctrb = $b;
       }

       if($row2[3] and ($row2[0]/1000+$row2[1]/1000+$row2[4]/1000)==($row2[3]/1000))
       { $format=$yellow; $format2=$orange;
         $totalangbyr+=($row2[0]/1000);
       }
       else
       { $format=""; $format2=$grey;
       }

       $bunga=$row2[1]/1000;
       $sisa = ($row2[1] - $bunga*1000)%100;
       if($sisa>0){ $bunga = $bunga.".".$sisa; }

       $ang=$row2[0]/1000;
       $sisa = ($row2[0] - $ang*1000)%100;
       if($sisa>0){ $ang = $ang.".".$sisa; }

       $denda=$row2[4]/1000;
       $sisa = ($row2[4] - $denda*1000)%100;
       if($sisa>0){ $denda = $denda.".".$sisa; }

       $worksheet->write($baris, $kolom,  $ang, $format); $kolom++;
       $worksheet->write($baris, $kolom,  $bunga, $format2); $kolom++;
       $worksheet->write($baris, $kolom,  $denda, $format2); $kolom++;
       $totalang+=$ang;
       $totalbunga+=$bunga;
       $totaldenda+=$denda;
       $totalblna[$ctrb]+=$ang;
       $totalblnb[$ctrb]+=$bunga;
       $totalblnd[$ctrb]+=$denda;
       $ctrb++;
    }


    $sisapinj=0;
  $qrtot = $dbk3->prepare("select sum(hrsbayar/1000), sum(bunga/1000), sum(denda/1000), sum(jmlbayar/1000) from angsuran  where pinjaman_id = $row[7]  and batal='N' and dtbayar is not null");
#  print "select sum(jmlbayar), sum(bunga), sum(denda) from angsuran  where pinjaman_id = $row[7]  and batal='N'";
  $qrtot->execute();
  @rstot = $qrtot->fetchrow_array();

  $totalang = $rstot[0] ;
  $totalbunga = $rstot[1];
  $totaldenda = $rstot[2];
  
    if($row[8] eq 'N') {
#    $sisapinj = $row[4]-$totalangbyr;
        $sisapinj = $row[4]-$rstot[0];
    }
    $totalsisapinj+=$sisapinj;
    $worksheet->write($baris, 42,  $totalang, $formatbaris);
    $worksheet->write($baris, 43,  $totalbunga, $formatbaris);
    $worksheet->write($baris, 44,  $totaldenda, $formatbaris);
    $worksheet->write($baris, 45,  $sisapinj, $formatbaris);

    $no++;
    $tmpcab=$row[3];
    $totalpinjam+=$row[4];
    $baris++;
  }

  $worksheet->write($baris, 0,  "TOTAL", $bold);
  $worksheet->write($baris, 5,  "$totalpinjam", $boldr);
  $totalallp=0; $totalalls=0;
  for ($i=1, $f=6, $g=8; $i<=12; $i++, $f+=3, $g+=3)
  { $totala+=$totalblna[$i];
    $totalb+=$totalblnb[$i];
    $totald+=$totalblnd[$i];
    $worksheet->write($baris, $f,  $totalblna[$i], $boldr);
    $worksheet->write($baris, $f+1,  $totalblnb[$i], $boldrgrey);
    $worksheet->write($baris, $g,  $totalblnd[$i], $boldrgrey);
  }

  $worksheet->write($baris, 42, $totala, $boldr);
  $worksheet->write($baris, 43, $totalb, $boldrgrey);
  $worksheet->write($baris, 44, $totald, $boldrgrey);
  $worksheet->write($baris, 45, $totalsisapinj, $boldrgrey);

  print qq~<span class=styleTitle><a href=/tmpkop/$temp02 class='hurufcol'>Download Di Sini</a></span>  <br/> <br/>~;
}

print qq~

  <table width='1200px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" width=50 rowspan=2><b>No.</b></td>
   <td align='center' class="hurufcol" width=100 rowspan=2> <b>NIK</b></td>
   <td align='center' class="hurufcol" width=220 rowspan=2> <b>Nama Peminjam</b> </td>
   <td align='center' class="hurufcol" width=50 rowspan=2> <b> Mulai Cicil</b></td>
   <td align='center' class="hurufcol" width=50 rowspan=2> <b> Masa Cicil</b></td>
   <td align='center' class="hurufcol" width=80 rowspan=2> <b> Jumlah Pinjaman</b></td>
   ~;
for ($i=1; $i<=12; $i++)
{ $bulan = genfuncpyl::format_bulan2($i);
  $bulan = substr $bulan,0,3;
  print qq~<td colspan=3 align='center' class="hurufcol" ><b> $bulan </b></td>~;
}
print qq~
   <td align='center' class="hurufcol" width=50 rowspan=2> <b> Total Angsuran</b></td>
   <td align='center' class="hurufcol" width=50 rowspan=2 bgcolor=$bgbungadark> <b> Total Bunga</b></td>
   <td align='center' class="hurufcol" width=50 rowspan=2 bgcolor=$bgbungadark> <b> Total Denda</b></td>
   <td align='center' class="hurufcol" width=50 rowspan=2> <b> Sisa Pinjaman</b></td>
  </tr>
   <tr bgcolor="$dark">
~;
for ($i=1; $i<=12; $i++)
{ $totalblna[$i]=0;
  $totalblnb[$i]=0;
  $totalblnd[$i]=0;
  
  $totalbyra[$i]=0;
  $totalbyrb[$i]=0;
  $totalbyrd[$i]=0;

  print qq~<td align='center' class="hurufcol" width=50><b>A</b></td>
           <td align='center' class="hurufcol" width=50 bgcolor=$bgbunga><b>B</b></td>
           <td align='center' class="hurufcol" width=50 bgcolor=$bgbunga><b>D</b></td>~;
}
print qq~  </tr>~;

$subq="";
if ($in{cabang}) { $subq.=" AND kodecabang='$in{cabang}' "; }
if ($in{lunas}) { $subq.=" AND lunas='$in{lunas}' "; }
#if ($in{vaktif}) { $subq.=" AND a.aktif='$in{vaktif}' "; }

$q = $dbk->prepare("select nik, nlengkap, p.idlama, kodecabang, jmlapprove/1000, masacicil, dtapprove, p.recid, lunas
from pinjaman p, getkry k, anggota a
where p.idlama=k.idlama and p.idlama=a.idlama and p.batal='N' $subq
 order by dtapprove, jmlapprove");

$q->execute();
$no=1;
$tmpcab='';  $totala=0; $totalb=0; $totalpinjam=0;
while (@row = $q->fetchrow_array())
{
#  if ($tmpcab and $tmpcab ne $row[3]) { print qq~<tr bgcolor=$dark height=5><td colspan=7></td> </tr>~; }
  $dtstart = genfuncpyl::mdytodmy($row[6]);
  $dtstart = substr $dtstart,0,5;

  if($row[8] eq 'Y'){ $bg="#ddd"; $bg2="#eee"; }
  elsif($no%2==0) { $bg=$colcolor; $bg2=$bgbunga; }
  else { $bg=$colcolor2;  $bg2=$bgbunga2; }
    print qq~
  <tr bgcolor=$bg height=20>
     <td align='center' class="hurufcol" valign="top">$no.</td>
     <td align='center' class="hurufcol" valign="top">$row[0]</td>
     <td class="hurufcol" valign="top"><a class='iframe' href='/cgi-bin/kopbox.cgi?display=kop021p&pid=$row[7]&ss=$in{ss}'>$row[1]</a></td>
     <td align='right' class="hurufcol" valign="top">$dtstart</td>
     <td align='right' class="hurufcol" valign="top">$row[5]</td>
     <td align='right' class="hurufcol" valign="top">$row[4]</td>
   ~;
  $q2 = $dbk2->prepare("select hrsbayar, bunga, periode, jmlbayar, denda from angsuran  where pinjaman_id = $row[7] and periode like '$in{tahun}%' and batal='N'
        order by periode");
  $q2->execute();
  $totalang=0; $totalbunga=0; $ctrb=1; $b=0;  $totaldenda=0; $totalangbyr=0;
  while (@row2 = $q2->fetchrow_array())
  {  $b = substr $row2[2],5,2;   $b = $b-0;
     if($ctrb!=$b)
     { for ($i=$ctrb; $i<=($b-1); $i++){ print qq~<td class="hurufcol">&nbsp;</td><td class="hurufcol" bgcolor=$bg2>&nbsp;</td><td class="hurufcol" bgcolor=$bg2>&nbsp;</td>~; }
       $ctrb = $b;
     }
     
     if($row2[3] and ($row2[0]/1000+$row2[1]/1000+$row2[4]/1000)==($row2[3]/1000))
     { $bgkolom1 = "bgcolor=#F3F781"; $bgkolom2 = "bgcolor=#F2F5A9"; $totalangbyr+=($row2[0]/1000);
       $totalbyra[$ctrb]+=$row2[0]/1000;
       $totalbyrb[$ctrb]+=$row2[1]/1000;
       $totalbyrd[$ctrb]+=$row2[4]/1000;
     }
     else
     { $bgkolom1=""; $bgkolom2="bgcolor=$bg2";
     }
     
     $bunga=$row2[1]/1000;
     $sisa = ($row2[1] - $bunga*1000)%100;
     if($sisa>0){ $bunga = $bunga.".".$sisa; }

     $ang=$row2[0]/1000;
     $sisa = ($row2[0] - $ang*1000)%100;
     if($sisa>0){ $ang = $ang.".".$sisa; }

     $denda=$row2[4]/1000;
     $sisa = ($row2[4] - $denda*1000)%100;
     if($sisa>0){ $denda = $denda.".".$sisa; }

     print qq~<td align='right' class="hurufcol" valign="top" $bgkolom1>$ang</td>
     <td align='right' class="hurufcol" valign="top" $bgkolom2>$bunga</td>
     <td align='right' class="hurufcol" valign="top" $bgkolom2>$denda</td>~;
     $totalang+=$ang;
     $totalbunga+=$bunga;
     $totaldenda+=$denda;
     $totalblna[$ctrb]+=$ang;
     $totalblnb[$ctrb]+=$bunga;
     $totalblnd[$ctrb]+=$denda;
     $ctrb++;
  }

  if($b!=12)
  {  for ($i=$b+1; $i<=12; $i++){ print qq~<td class="hurufcol">&nbsp;</td><td class="hurufcol"  bgcolor=$bg2>&nbsp;</td><td class="hurufcol" bgcolor=$bg2>&nbsp;</td>~; }
  }
  $sisapinj=0;
  $qrtot = $dbk3->prepare("select sum(hrsbayar/1000), sum(bunga/1000), sum(denda/1000), sum(jmlbayar/1000) from angsuran  where pinjaman_id = $row[7]  and batal='N' and dtbayar is not null");
#  print "select sum(jmlbayar), sum(bunga), sum(denda) from angsuran  where pinjaman_id = $row[7]  and batal='N'";
  $qrtot->execute();
  @rstot = $qrtot->fetchrow_array();

  $totalang = $rstot[0] ;
  $totalbunga = $rstot[1];
  $totaldenda = $rstot[2];
  if($row[8] eq 'N') {
#  $sisapinj = $row[4]-$totalangbyr;
$sisapinj = $row[4]-$rstot[0];
  }
  print qq~
     <td align='right' class="hurufcol" valign="top"><b>$rstot[0]</b></td>
     <td align='right' class="hurufcol" valign="top" bgcolor=$bg2><b> $rstot[1]</b></td>
     <td align='right' class="hurufcol" valign="top" bgcolor=$bg2><b> $rstot[2]</b></td>
     <td align='right' class="hurufcol" valign="top"><b>$sisapinj </b></td>
  </tr> ~;
   
  $no++;
  $tmpcab=$row[3];
  $totalpinjam+=$row[4];
  $totalsisapinj+=$sisapinj;
}

    print qq~
  <tr bgcolor=$dark height=20>
     <td align='left' class="hurufcol" colspan=5><b>TOTAL BYR</b></td>
     <td align='right' class="hurufcol" valign="top"><b></b></td> ~;
for ($i=1; $i<=12; $i++)
{ $totalbya+=$totalbyra[$i];
  $totalbyb+=$totalbyrb[$i];
  $totalbyd+=$totalbyrd[$i];
  print qq~<td align='right' class="hurufcol" width=50 bgcolor=#F3F781>$totalbyra[$i]</td>
           <td align='right' class="hurufcol" width=50 bgcolor=#F2F5A9>$totalbyrb[$i]</td>
           <td align='right' class="hurufcol" width=50 bgcolor=#F2F5A9>$totalbyrd[$i]</td>~;
}

  print qq~ <td align='right' class="hurufcol" valign="top" bgcolor=#F3F781><b>$totalbya</b></td>
     <td align='right' class="hurufcol" valign="top" bgcolor=F2F5A9><b>$totalbyb</b></td>
     <td align='right' class="hurufcol" valign="top" bgcolor=F2F5A9><b>$totalbyc</b></td>
     <td align='right' class="hurufcol" valign="top"><b></b></td>
  </tr>
  <tr bgcolor=$dark height=20>
     <td align='left' class="hurufcol" colspan=5><b>TOTAL</b></td>
     <td align='right' class="hurufcol" valign="top"><b>$totalpinjam</b></td> ~;
$totalallp=0; $totalalls=0;
for ($i=1; $i<=12; $i++)
{ $totala+=$totalblna[$i];
  $totalb+=$totalblnb[$i];
  $totald+=$totalblnd[$i];
  print qq~<td align='right' class="hurufcol" width=50>$totalblna[$i]</td>
           <td align='right' class="hurufcol" width=50 bgcolor=$bgbungadark>$totalblnb[$i]</td>
           <td align='right' class="hurufcol" width=50 bgcolor=$bgbungadark>$totalblnd[$i]</td>~;
}

  print qq~ <td align='right' class="hurufcol" valign="top"><b>$totala</b></td>
     <td align='right' class="hurufcol" valign="top" bgcolor=$bgbungadark><b>$totalb</b></td>
     <td align='right' class="hurufcol" valign="top" bgcolor=$bgbungadark><b>$totald</b></td>
     <td align='right' class="hurufcol" valign="top"><b>$totalsisapinj</b></td>
  </tr>
  </table>
 ~;

print qq ~
    <hr width="100" />
</center>
~;
}

;
1

