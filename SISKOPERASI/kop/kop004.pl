sub kop004 {

use Spreadsheet::WriteExcel;
genfunckop::view_header_kop($in{ss}, $s3s[2], 'Master Anggota', $s3s[17]);
genfunckop::validasi_akses_kop($s3s[11], $in{ss});
@aktif = ("Y", "N");
if(!$in{vaktif}){ $in{vaktif}="Y"; }

($month,$day,$year,$aweekday) = &jdate(&today());
$month = substr "0$month",-2;
$day = substr "0$day",-2;

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
      width:"950px",
      height:"80%"});

    \$("#click").click(function(){
	 \$(".iframe").colorbox.close();
    });
});
</script>


     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=150>
     &nbsp;
     </td>
     <td align=center> <h2 class="hurufcol"> MASTER ANGGOTA</h2> </td>
     <td align=right width=150>~;
if ($s3s[11] eq 'S')
{     print qq~
      <a class='iframe' href='/cgi-bin/kopbox.cgi?display=kop004c&ss=$in{ss}'><img src='/images/add.png'></a>
       ~;
}     print qq~ </td>
     </tr>
     </table>

<form action="/cgi-bin/siskop.cgi" method="post" name='vq'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=kop004>
<table>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> &nbsp; Cabang </td>
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
    <td class="hurufcol" width=100> &nbsp; Aktif </td>
    <td class="hurufcol" ><select name="vaktif" class="huruf1" id="vaktif">
    ~;
for ($i=0; $i<@aktif; $i++)
{  $selected="";
   if ($in{vaktif} eq $aktif[$i]) { $selected="selected"; }
   print qq~<option value='$aktif[$i]' $selected> $aktif[$i] </option>~;
}
print qq~
    </select>
    </td>
    <td><input type='submit' name='view' value='Go'>~;
print qq~<input type='submit' name='export' value='Export'>~;
print qq~
    </td>
  </tr>
</table>
</form>    ~;

if ($in{aktif})
{  $q = $dbk->do("update anggota set aktif='$in{aktif}', oprupdate='$s3s[0]' where recid='$in{arecid}'; ");
   if($q!=0){  print qq~<div class=warning_ok>Sukses Ubah Aktif Anggota</div>~; }
   else {  print qq~<div class=warning_not_ok>Gagal Ubah Aktif Anggota</div>~; }
}


if($in{export})
{
  $temp01="/home/$folder_user/htdocs/tmpkop/Anggota_".$year.$month.$day.".xls";
  $temp02='Anggota_'.$year.$month.$day.'.xls';

  my $workbook  = Spreadsheet::WriteExcel->new($temp01);
  my $worksheet = $workbook->add_worksheet();

  $worksheet->set_column(0, 0, 5);
  $worksheet->set_column(1, 1, 20);
  $worksheet->set_column(2, 2, 10);
  $worksheet->set_column(3, 3, 33);
  $worksheet->set_column(4, 6, 10);

  $worksheet->write(0, 0,  "No.");
  $worksheet->write(0, 1,  "Cabang");
  $worksheet->write(0, 2,  "NIK");
  $worksheet->write(0, 3,  "Nama");
  $worksheet->write(0, 4,  "Tgl Join");
  $worksheet->write(0, 5,  "Simpanan Pokok");
  $worksheet->write(0, 6,  "Simpanan Sukarela");
  $worksheet->write(0, 7,  "Tgl Keluar");
  $worksheet->write(0, 8,  "Aktif");

  $subq="";
  if ($in{cabang}) { $subq=" AND kodecabang='$in{cabang}' "; }
  if ($in{vaktif}) { $subq=" AND a.aktif='$in{vaktif}' "; }

  $q = $dbk->prepare("select kodecabang, namastore, nik, nlengkap, dtjoin, jenis, jumlah, a.idlama, a.aktif, a.recid, dtkeluar
from anggota a, getkry k, simpanan s
where a.idlama=k.idlama and a.idlama=s.idlama and dtexpired='1/1/2099'   $subq
order by kodecabang, nlengkap, jenis ");
  $q->execute();
  $no=1; $baris=1;
  $tmpdep=''; $ctr = 1; $totalp=0; $totals=0;
  while (@row = $q->fetchrow_array())
  { $dtna="";
    if($row[10]) { $dtna = genfuncpyl::mdytodmy($row[10]); }

    if($ctr%2==0)
    { $tgljoin=genfuncpyl::mdytodmy($row[4]);

      $worksheet->write($baris, 0,  $no);
      $worksheet->write($baris, 1,  "$row[0]-$row[1]");
      $worksheet->write($baris, 2,  $row[2]);
      $worksheet->write($baris, 3,  $row[3]);
      $worksheet->write($baris, 4,  $tgljoin);
      $worksheet->write($baris, 5,  $pokok);
      $worksheet->write($baris, 6,  $row[6]);
      $worksheet->write($baris, 7,  $dtna);
      $worksheet->write($baris, 8,  $row[8]);

      $no++; $baris++;
      $totalp+=$pokok;
      $totals+=$row[6];

    }
    else
    { $pokok=$row[6];
    }
    $ctr++;
  }
  $worksheet->write($baris, 0,  "TOTAL");
  $worksheet->write($baris, 5,  $totalp);
  $worksheet->write($baris, 6,  $totals);
  print qq~<span class=styleTitle><a href=/tmpkop/$temp02 class='hurufcol'>Download Di Sini</a></span>  <br/> <br/>~;
}

if ($s3s[11] eq 'S')
{
print qq ~
<script type="text/javascript">
function toAktif(u, f)
{   with(document.mst)
          {  arecid.value = u;
             aktif.value = f;
             submit();
          }
}
</script>
<FORM ACTION="/cgi-bin/siskop.cgi" METHOD="post" name='mst'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=kop004>
  <input type=hidden name=arecid value=''>
  <input type=hidden name=aktif value=''>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
 ~;
}
print qq~
  <table width='1100px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" width=50><b>No.</b></td>
   <td align='center' class="hurufcol" width=180><b>Cabang</b></td>
   <td align='center' class="hurufcol" width=100> <b>NIK</b></td>
   <td align='center' class="hurufcol" width=220> <b>Nama Anggota</b> </td>
   <td align='center' class="hurufcol" width=80> <b>Tgl Join</b> </td>
   <td align='center' class="hurufcol" width=100> <b>Simpanan Pokok</b></td>
   <td align='center' class="hurufcol" width=100> <b>Simpanan Sukarela</b></td>
   <td align='center' class="hurufcol" width=100> <b>Tgl Keluar</b></td>
   <td align='center' class="hurufcol" width=100> <b>Aktif</b></td>
  </tr>
~;

$subq="";
if ($in{cabang}) { $subq=" AND kodecabang='$in{cabang}' "; }
if ($in{vaktif}) { $subq=" AND a.aktif='$in{vaktif}' "; }

#if($s3s[0] eq 'XTIN')
#{ print qq~select kodecabang, namastore, nik, nlengkap, dtjoin, jenis, jumlah, a.idlama, a.aktif, a.recid, dtkeluar
#from anggota a, getkry k, simpanan s
#where a.idlama=k.idlama and a.idlama=s.idlama and dtexpired='1/1/2099'   $subq
#order by kodecabang, nlengkap, jenis <br/> ~;
#}

$q = $dbk->prepare("select kodecabang, namastore, nik, nlengkap, dtjoin, jenis, jumlah, a.idlama, a.aktif, a.recid, dtkeluar
from anggota a, getkry k, simpanan s
where a.idlama=k.idlama and a.idlama=s.idlama and dtexpired='1/1/2099'   $subq
order by kodecabang, nlengkap, jenis ");
$q->execute();
$no=1;
$tmpdep=''; $ctr = 1; $totalp=0; $totals=0;
while (@row = $q->fetchrow_array())
{ if ($tmpdep and $tmpdep ne $row[0]) { print qq~<tr bgcolor=$dark height=5><td colspan=9></td> </tr>~; }

  $dtna="";
  if($row[10]) { $dtna = genfuncpyl::mdytodmy($row[10]); }

  $btn="";
  if($s3s[11] eq 'S' and $row[8] eq 'Y')
  { #if($row[8] eq 'Y'){
     $namabtn="Nonaktif"; $flag='N';
    #}
    #else { $namabtn="Aktif"; $flag='Y';  }
    $btn="<input type=button value=$namabtn name=btnaktif onClick=\"toAktif('$row[9]','$flag')\"/>";
  }
  
  if($ctr%2==0)
  { $tgljoin=genfuncpyl::mdytodmy($row[4]);
    $txtpokok = genfuncpyl::ribuan($pokok);
    $txtsukarela = genfuncpyl::ribuan($row[6]);
    if($no%2==0){ $bg=$colcolor; }
    else { $bg=$colcolor2; }
    print qq~
  <tr bgcolor=$bg height=20>
     <td align='center' class="hurufcol" valign="top">$no.</td>
     <td class="hurufcol" valign="top">$row[0]-$row[1]</td>
     <td align='center' class="hurufcol" valign="top">$row[2]</td>
     <td class="hurufcol" valign="top"><a class='iframe' href='/cgi-bin/kopbox.cgi?display=kop004d&idlama=$row[7]&ss=$in{ss}&s3s11=$s3s[11]'>$row[3]</a></td>
     <td align='center' class="hurufcol" valign="top">$tgljoin</td>
     <td align='right' class="hurufcol" valign="top">$txtpokok</td>
     <td align='right' class="hurufcol" valign="top">$txtsukarela</td>
     <td align='center' class="hurufcol" valign="top">$dtna</td>
     <td align='center' class="hurufcol" valign="top">$row[8] $btn</td>
  </tr>
    ~;
    $no++;
    $totalp+=$pokok;
    $totals+=$row[6];

  }
  else
  { $pokok=$row[6];
  }

  $ctr++;
  $tmpdep=$row[0];
}

    $txttotalp = genfuncpyl::ribuan($totalp);
    $txttotals = genfuncpyl::ribuan($totals);
    print qq~
  <tr bgcolor=$dark height=20>
     <td align='left' class="hurufcol" colspan=5><b>TOTAL</b></td>
     <td align='right' class="hurufcol" valign="top"><b>$txttotalp</b></td>
     <td align='right' class="hurufcol" valign="top"><b>$txttotals</b></td>
     <td align='right' class="hurufcol" valign="top">&nbsp; </td>
     <td align='right' class="hurufcol" valign="top">&nbsp; </td>
  </tr>
  </table>  ~;

if ($s3s[11] eq 'S')
{  print qq ~</form>~;
}

print qq ~  Note : Aktif=N berarti Iuran tidak dibayarkan di bulan ini
    <hr width="100" />
</center>
~;
}

;
1

