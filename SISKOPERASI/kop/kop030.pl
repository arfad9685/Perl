sub kop030 {

use Spreadsheet::WriteExcel;
use Date::Calc qw(Days_in_Month);
genfunckop::view_header_kop($in{ss}, $s3s[2], 'Report Saldo', $s3s[17]);
genfunckop::validasi_akses_kop($s3s[11], $in{ss});
&koneksi_kop2;
$bgbunga2 = "#c9f7ad";
$bgbunga = "#bfe8a7";
$bgbungadark = "#a9e884";

($month,$day,$year,$aweekday) = &jdate(&today());
$month = substr "0$month",-2;
$day = substr "0$day",-2;
if(!$in{tahun}){ $in{tahun}=$year; }

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
     &nbsp;
     </td>
     <td align=center> <h2 class="hurufcol"> REPORT SALDO</h2> </td>
     <td align=left width=120>&nbsp;</td>
     </tr>
     </table>

<form action="/cgi-bin/siskop.cgi" method="post" name='vq'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=kop030>
<table>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> &nbsp; Tahun </td>
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
    <td><input type='submit' name='view' value='Go'>~;
print qq~<input type='submit' name='export' value='Export'>~;
print qq~</td>
  </tr>
</table>
</form>    ~;

if($in{export})
{
  $temp01="/home/$folder_user/htdocs/tmpkop/RptSaldo_".$year.$month.$day.".xls";
  $temp02='RptSaldo_'.$year.$month.$day.'.xls';

  my $workbook  = Spreadsheet::WriteExcel->new($temp01);
  my $worksheet = $workbook->add_worksheet();

  $worksheet->set_column(0, 0, 10);
  $worksheet->set_column(1, 11, 15);

  my $mboldcenter = $workbook->addformat();
  $mboldcenter->set_align('center');
  $mboldcenter->set_bold();
  $mboldcenter->set_size('11');

  $worksheet->write(0, 0,  "Periode");
  $worksheet->write(0, 1,  "Pokok");
  $worksheet->write(0, 2,  "Sukarela");
  $worksheet->write(0, 3,  "Angsuran");
  $worksheet->write(0, 4,  "Bunga");
  $worksheet->write(0, 5,  "Denda");
  $worksheet->write(0, 6,  "Plus Lain2");
  $worksheet->write(0, 7,  "Pinjaman");
  $worksheet->write(0, 8,  "Pencairan");
  $worksheet->write(0, 9,  "Minus Lain2");
  $worksheet->write(0, 10,  "Saldo Per Bulan");
  $worksheet->write(0, 11,  "Uang Masuk");

  $q = $dbk->prepare("select recid, saldoawal, pokok, sukarela, angsuran, angbunga, angdenda, pluslain, pinjaman, minuslain, saldoakhir, pencairan from saldo
where recid like '$in{periode}%'
order by recid");
  $q->execute();
  $saldoawal=0; $pokok=0; $sukarela=0; $angsuran=0; $angbunga=0; $angdenda=0; $plus=0; $pinjaman=0; $minus=0; $saldoakhir=0;  $totalselisih=0;  $pencairan=0;
  $no=1; $baris=1;
  while (@row = $q->fetchrow_array())
  {
    $saldoawal+=$row[1];
    $pokok+=$row[2];
    $sukarela+=$row[3];
    $angsuran+=$row[4];
    $angbunga+=$row[5];
    $angdenda+=$row[6];
    $plus+=$row[7];
    $pinjaman+=$row[8];
    $minus+=$row[9];
    $saldoakhir+=$row[10];
    $pencairan+=$row[11];
    $selisih = $row[10] - $row[1];
    $totalselisih+=$selisih;

    $worksheet->write($baris, 0,  "$row[0]");
    $worksheet->write($baris, 1,  $row[2]);
    $worksheet->write($baris, 2,  $row[3]);
    $worksheet->write($baris, 3,  $row[4]);
    $worksheet->write($baris, 4,  $row[5]);
    $worksheet->write($baris, 5,  $row[6]);
    $worksheet->write($baris, 6,  $row[7]);
    $worksheet->write($baris, 7,  $row[8]);
    $worksheet->write($baris, 8,  $row[11]);
    $worksheet->write($baris, 9,  $row[9]);
    $worksheet->write($baris, 10,  $row[10]);
    $worksheet->write($baris, 11,  $selisih);
    $no++; $baris++;
  }

  $worksheet->write($baris, 1,  $pokok);
  $worksheet->write($baris, 2,  $sukarela);
  $worksheet->write($baris, 3,  $angsuran);
  $worksheet->write($baris, 4,  $angbunga);
  $worksheet->write($baris, 5,  $angdenda);
  $worksheet->write($baris, 6,  $plus);
  $worksheet->write($baris, 7,  $pinjaman);
  $worksheet->write($baris, 8,  $pencairan);
  $worksheet->write($baris, 9,  $minus);
  $worksheet->write($baris, 10,  $saldoakhir);
  $worksheet->write($baris, 11,  $totalselisih);
  print qq~<span class=styleTitle><a href=/tmpkop/$temp02 class='hurufcol'>Download Di Sini</a></span>  <br/> <br/>~;
}

if($in{periodeproses})
{
  $q = $dbk->prepare("select saldoakhir from saldo where recid<'$in{periodeproses}' order by recid desc rows 1 to 1");
  $q->execute();
  @row = $q->fetchrow_array();
  if($row[0]){ $saldoawal=$row[0]; }
  else { $saldoawal=79728400 ; }

  $pokok=0; $sukarela=0;
  $q = $dbk->prepare("select jmlp, jmls from
  (select sum(hrsbayar) jmlp from iuran where jenis='P' and periode='$in{periodeproses}') p,
  (select sum(hrsbayar) jmls from iuran where jenis='S' and periode='$in{periodeproses}') s");
  $q->execute();
  @row = $q->fetchrow_array();
  if($row[0]){ $pokok=$row[0]; $sukarela=$row[1]; }

  $q = $dbk->prepare("select coalesce(sum(hrsbayar),0), coalesce(sum(bunga),0), coalesce(sum(denda),0) from angsuran
  where periode='$in{periodeproses}' and batal='N' and jmlbayar>0");
  $q->execute();
  @row = $q->fetchrow_array();
  $angsuran=$row[0]; $angbunga=$row[1];  $angdenda=$row[2];
  
  $q = $dbk->prepare("
  select coalesce(jmlp,0), coalesce(jmlm,0), coalesce(jmlc,0) from
  (select sum(jumlah) jmlp from plus where  periode='$in{periodeproses}' and batal='N') p,
  (select sum(jumlah) jmlm from minus where  periode='$in{periodeproses}' and batal='N') m,
  (select sum(jumlah) jmlc from pencairan where  periode='$in{periodeproses}' and batal='N') c");
  $q->execute();
  @row = $q->fetchrow_array();
  $plus=$row[0];  $minus=$row[1];  $cair=$row[2];

  $q = $dbk->prepare("select coalesce(sum(jmlpengajuan),0) from pinjaman where periode='$in{periodeproses}' and batal='N' ");
  $q->execute();
  @row = $q->fetchrow_array();
  $pinjaman=$row[0];
  
  $saldoakhir = $saldoawal+$pokok+$sukarela+$angsuran+$angbunga+$angdenda+$plus - $pinjaman - $minus;
#  if($s3s[0] eq 'XTIN')
#  { print qq~update saldo set saldoawal='$saldoawal', pokok='$pokok', sukarela='$sukarela', angsuran='$angsuran', angbunga='$angbunga', angdenda='$angdenda',
#    pluslain='$plus', pinjaman='$pinjaman', minuslain='$minus', pencairan='$cair', saldoakhir='$saldoakhir', oprupdate='$s3s[0]'  where recid='$in{periodeproses}'; <br/> ~;
#  }
  $q1=$dbk->do("update saldo set saldoawal='$saldoawal', pokok='$pokok', sukarela='$sukarela', angsuran='$angsuran', angbunga='$angbunga', angdenda='$angdenda',
  pluslain='$plus', pinjaman='$pinjaman', minuslain='$minus', pencairan='$cair', saldoakhir='$saldoakhir', oprupdate='$s3s[0]'  where recid='$in{periodeproses}';");

  $q = $dbp->prepare("select recid from periodsc where recid>'$in{periodeproses}' order by recid asc rows 1 to 1");
  $q->execute();
  @row = $q->fetchrow_array();
  if(!$row[0])
  {  print qq~<div class=warning_ok>Sukses Update Saldo Periode '$in{periodeproses}' <b>TANPA</b> Update Saldo Periode Baru</div>~;
  }
  else
  { $nextprid=$row[0];
    $y = substr  $nextprid,0,4;
    $m = substr  $nextprid,5,2;
    $days = Days_in_Month($y,$m);

    $q = $dbk->prepare("select recid from PERIODE where recid='$nextprid'");
    $q->execute();
    @row = $q->fetchrow_array();
    if(!$row[0])
    {
      $q2=$dbk->do("INSERT INTO PERIODE (RECID, DTSTART, DTFINISH, DTMAXIURAN, DTMAXANGSUR, OPRCREATE) VALUES
      ('$nextprid', '$m/01/$y', '$m/$days/$y', '$m/05/$y', '$m/05/$y', '$s3s[0]');");
    }

    $q = $dbk->prepare("select recid from saldo where recid='$nextprid'");
    $q->execute();
    @row = $q->fetchrow_array();
    if(!$row[0])
    { $q3=$dbk->do("insert into saldo(recid, saldoawal, oprcreate) values ('$nextprid',$saldoakhir,'$s3s[0]');");
    }
    else
    { $q3=$dbk->do("update saldo set saldoawal='$saldoakhir', oprupdate='$s3s[0]' where recid='$nextprid';");
    }
  
    if($q1!=0 && $q3!=0){ print qq~<div class=warning_ok>Sukses Update Saldo Periode '$in{periodeproses}' Dan Update Saldo Periode Baru</div> ~; }
    else { print qq~<div class=warning_not_ok>Gagal Update Saldo Periode '$in{periodeproses}' q1=$q1 q3=$q3</div> ~; }
  }
  
}

print qq~
  <table width='1200px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" width=50><b>Periode</b></td>
   <td align='center' class="hurufcol" width=60> <b>Pokok</b> </td>
   <td align='center' class="hurufcol" width=60> <b>Sukarela</b></td>
   <td align='center' class="hurufcol" width=60> <b>Angsuran</b></td>
   <td align='center' class="hurufcol" width=60> <b>Bunga</b></td>
   <td align='center' class="hurufcol" width=60> <b>Denda</b></td>
   <td align='center' class="hurufcol" width=60> <b>Plus Lain2</b></td>
   <td align='center' class="hurufcol" width=60> <b>Pinjaman</b></td>
   <td align='center' class="hurufcol" width=60> <b>Pencairan</b></td>
   <td align='center' class="hurufcol" width=60> <b>Minus Lain2</b></td>
   <td align='center' class="hurufcol" width=80> <b>Saldo Per Bulan</b></td>
   <td align='center' class="hurufcol" width=80> <b>Uang Masuk</b></td>
   <td align='center' class="hurufcol" width=80> <b>Action</b></td>
  </tr>
~;

$q = $dbk->prepare("select recid, saldoawal, pokok, sukarela, angsuran, angbunga, angdenda, pluslain, pinjaman, minuslain, saldoakhir, pencairan from saldo
where recid like '$in{tahun}%'
order by recid");
$q->execute();
$saldoawal=0; $pokok=0; $sukarela=0; $angsuran=0; $angbunga=0; $angdenda=0; $plus=0; $pinjaman=0; $minus=0; $saldoakhir=0;  $totalselisih=0;  $pencairan=0;
$no=1;
while (@row = $q->fetchrow_array())
{
  if($no%2==0) { $bg=$colcolor; $bg2=$bgbunga; }
  else { $bg=$colcolor2;  $bg2=$bgbunga2; }

  $saldoawal+=$row[1];
  $pokok+=$row[2];
  $sukarela+=$row[3];
  $angsuran+=$row[4];
  $angbunga+=$row[5];
  $angdenda+=$row[6];
  $plus+=$row[7];
  $pinjaman+=$row[8];
  $minus+=$row[9];
  $saldoakhir+=$row[10];
  $pencairan+=$row[11];
  $selisih = $row[10] - $row[1];
  $totalselisih+=$selisih;

  $txtsaldoawal = genfuncpyl::ribuan($row[1]);
  $txtpokok = genfuncpyl::ribuan($row[2]);
  $txtsukarela = genfuncpyl::ribuan($row[3]);
  $txtangsuran = genfuncpyl::ribuan($row[4]);
  $txtangbunga = genfuncpyl::ribuan($row[5]);
  $txtangdenda = genfuncpyl::ribuan($row[6]);
  $txtplus = genfuncpyl::ribuan($row[7]);
  $txtpinjaman = genfuncpyl::ribuan($row[8]);
  $txtminus = genfuncpyl::ribuan($row[9]);
  $txtsaldoakhir = genfuncpyl::ribuan($row[10]);
  $txtselisih = genfuncpyl::ribuan($selisih);
  $txtcair = genfuncpyl::ribuan($row[11]);
  print qq~
  <tr bgcolor=$bg height=20>
     <td align='center' class="hurufcol" valign="top" bgcolor=$dark>$row[0]</td>
     <!--<td align='right' class="hurufcol" valign="top">$txtsaldoawal</td>-->
     <td align='right' class="hurufcol" valign="top">$txtpokok</td>
     <td align='right' class="hurufcol" valign="top">$txtsukarela</td>
     <td align='right' class="hurufcol" valign="top">$txtangsuran</td>
     <td align='right' class="hurufcol" valign="top">$txtangbunga</td>
     <td align='right' class="hurufcol" valign="top">$txtangdenda</td>
     <td align='right' class="hurufcol" valign="top">$txtplus</td>
     <td align='right' class="hurufcol" valign="top" bgcolor=$bg2>$txtpinjaman</td>
     <td align='right' class="hurufcol" valign="top" bgcolor=$bg2>$txtcair</td>
     <td align='right' class="hurufcol" valign="top" bgcolor=$bg2>$txtminus</td>
     <td align='right' class="hurufcol" valign="top" bgcolor=$dark>$txtsaldoakhir</td>
     <td align='right' class="hurufcol" valign="top" bgcolor=$dark>$txtselisih</td>
     <td align='right' class="hurufcol" valign="top" bgcolor=$dark>
      ~;
      if($s3s[11] eq 'S')
      {
        print qq~<form method=post action="/cgi-bin/siskop.cgi" >
      <input type="submit" name="back" value="Proses" class="huruf1"/>
      <input name="pages" type="hidden" value=kop030>
      <input name="periodeproses" type="hidden" value=$row[0]>
      <input name="ss" type="hidden" value="$in{ss}">
      </form>~;
      }
      print qq~
      </td>
  </tr> ~;
   $no++;
}

  $txtsaldoawal=genfuncpyl::ribuan($saldoawal);
  $txtpokok=genfuncpyl::ribuan($pokok);
  $txtsukarela=genfuncpyl::ribuan($sukarela);
  $txtangsuran=genfuncpyl::ribuan($angsuran);
  $txtangbunga=genfuncpyl::ribuan($angbunga);
  $txtangdenda=genfuncpyl::ribuan($angdenda);
  $txtplus=genfuncpyl::ribuan($plus);
  $txtpinjaman=genfuncpyl::ribuan($pinjaman);
  $txtpencairan=genfuncpyl::ribuan($pencairan);
  $txtminus=genfuncpyl::ribuan($minus);
  $txtsaldoakhir=genfuncpyl::ribuan($saldoakhir);
  $txttotalselisih=genfuncpyl::ribuan($totalselisih);
    print qq~
  <tr bgcolor=$dark height=20>
     <td align='left' class="hurufcol"><b>TOTAL</b></td>
     <!--<td align='right' class="hurufcol" valign="top"><b>$txtsaldoawal</b></td>-->
     <td align='right' class="hurufcol" valign="top"><b>$txtpokok</b></td>
     <td align='right' class="hurufcol" valign="top"><b>$txtsukarela</b></td>
     <td align='right' class="hurufcol" valign="top"><b>$txtangsuran</b></td>
     <td align='right' class="hurufcol" valign="top"><b>$txtangbunga</b></td>
     <td align='right' class="hurufcol" valign="top"><b>$txtangdenda</b></td>
     <td align='right' class="hurufcol" valign="top"><b>$txtplus</b></td>
     <td align='right' class="hurufcol" valign="top"><b>$txtpinjaman</b></td>
     <td align='right' class="hurufcol" valign="top"><b>$txtpencairan</b></td>
     <td align='right' class="hurufcol" valign="top"><b>$txtminus</b></td>
     <td align='right' class="hurufcol" valign="top"><b>$txtsaldoakhir</b></td>
     <td align='right' class="hurufcol" valign="top"><b>$txttotalselisih</b></td>
     <td align='right' class="hurufcol" valign="top"><b>&nbsp;</b></td>
  </tr>
  </table>  ~;

print qq ~
    <hr width="100" />
</center>
~;
}

;
1

