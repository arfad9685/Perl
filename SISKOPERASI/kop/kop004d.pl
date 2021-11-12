sub kop004d {

genfunckop::validasi_akses_kop($s3s[11], $in{ss});
require "/home/hrdconf/cgi-bin/koneksi_pay.pl";
&koneksi_pay1;

print qq~
<script type='text/javascript' src='/jquery.min.js'></script>
<script type='text/javascript' src="/jquery.chained.js"></script>
<style type="text/css">
\@import url("/jscalendar/calendar-blue.css");
</style>

<script type="text/javascript" src="/jscalendar/calendar.js"></script>
<script type="text/javascript" src="/jscalendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="/jscalendar/calendar-setup.js"></script>
      <br/> &nbsp;<br/>
     <table width=100% border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=150>
     &nbsp;
     </td>
     <td align=center> <h2 class="hurufcol"> SIMPANAN ANGGOTA</h2> </td>
     <td align=left width=150> &nbsp; </td>
     </tr>
     </table>
     <br/>
~;

if($in{simpan})
{
   $in{sukarela}=~ s/\'/\ /g;
   $in{sukarela}=~ s/\"/\ /g;

   $wrn='';

   if (!($in{dtberlaku})) { $wrn.="<li>Tgl Berlaku</li>"; }
   if ($in{sukarela}<0) { $wrn.="<li>Simpanan Sukarela Baru Salah $in{sukarela}</li>"; }
   if ($in{sukarela}==$in{lama}) { $wrn.="<li>Simpanan Sukarela Baru dan Lama sama </li>"; }
#   print $in{dtberlaku}.$in{sukarela}.$in{lama}.$wrn;
   if ($wrn ne "" )
   {  $warning = "<div class='warning_not_ok'>Isilah field-field di bawah dengan format yang benar: $wrn</div><br/>";
   }
   else
   {
      $q1 = $dbk->do("INSERT INTO SIMPANAN (IDLAMA, JENIS, JUMLAH, DTBERLAKU, DTEXPIRED, OPRCREATE) VALUES
         ('$in{idlama}','S','$in{sukarela}','$in{dtberlaku}','1/1/2099','$s3s[0]'); ");
      if($q1!=0)
      { $warning= qq~<div class=warning_ok> Sukses Update Simpanan Sukarela</div> ~;
      }
      else
      { $warning= qq~<div class=warning_not_ok> Tidak Berhasil Update Simpanan Sukarela 2=$q2 </div> ~;
      }
   }
}
if($in{update} and $in{dtkeluar})
{
   $q = $dbk->do("update anggota set aktif='N',dtkeluar='$in{dtkeluar}', oprupdate='$s3s[0]' where recid='$in{arecid}'");
   if($q!=0){  print qq~<div class=warning_ok>Sukses Update Tgl Keluar Anggota</div>~; }
   else {  print qq~<div class=warning_not_ok>Gagal Update Tgl Keluar Anggota</div>~; }
}

$query = $dbk->prepare("select kodecabang, namastore, nik, nlengkap, dtjoin, dtkeluar, a.recid from anggota a, getkry k
where a.idlama=k.idlama and a.idlama=$in{idlama}
");
$query->execute();
@record = $query->fetchrow_array();
$dtberlaku = genfuncpyl::mdytodmy($record[4]);

$qy = $dby->prepare("select norek from rekening where idlama=$in{idlama} and bank='BCA' ");
$qy->execute();
@recy = $qy->fetchrow_array();

print qq~ $warning
<form action="/cgi-bin/kopbox.cgi" method="post" name='vq'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=display value=kop004d>
  <input type=hidden name=arecid value=$record[6]> ~; if($s3s[0] eq 'XTIN'){ print qq~idlama = $in{idlama}~; } print qq~
  <table width='500px' border='0' cellspacing='2' cellpadding='2'>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"  width=150> &nbsp; Karyawan </td>
    <td class="hurufcol"  bgcolor=$colcolor2> $record[2] - $record[3] </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp; Cabang </td>
    <td class="hurufcol"  bgcolor=$colcolor2> $record[0] - $record[1] </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp; Tgl Join  </td>
    <td class="hurufcol"  bgcolor=$colcolor2> $dtberlaku </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp; No. Rek BCA </td>
    <td class="hurufcol"  bgcolor=$colcolor2> $recy[0] </td>
  </tr>
  ~;
if($in{s3s11} eq 'S')
{
  print qq~
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp; Tgl Keluar </td>
    <td class="hurufcol"  bgcolor=$colcolor2> <input class='huruf1' name="dtkeluar" type="text" id="dtkeluar" size="12" maxlength="12" value="$record[5]" />
       <img src="/jscalendar/img.gif" id="trigger1" style="cursor: pointer; border: 1px solid blue;" title="Date selector" onMouseOver="this.style.background='blue';" onMouseOut="this.style.background=''" />
       <script type="text/javascript">
       Calendar.setup(
       {
        inputField  : "dtkeluar",         // ID of the input field
        ifFormat    : "%m/%d/%Y",    // the date format
        button      : "trigger1"       // ID of the button
	  //daFormat  :  "%Y/%m/%d"
        }
       );
       </script><input type='submit' name='update' value='Update'>  </td>
  </tr>
  ~;
}
print qq~
</table>
</form>

  <table width='500px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" width=50><b>No.</b></td>
   <td align='center' class="hurufcol" width=100><b>Jenis Simpanan</b></td>
   <td align='center' class="hurufcol" width=100> <b>Jumlah</b></td>
   <td align='center' class="hurufcol" width=100> <b>Tgl Berlaku</b> </td>
   <td align='center' class="hurufcol" width=100> <b>Tgl Expired</b> </td>
  </tr>~;

$query = $dbk->prepare("select jenis, jumlah, dtberlaku, dtexpired from simpanan where idlama=$in{idlama} order by jenis, dtexpired DESC");
$query->execute(); $no=1;
while(@rec = $query->fetchrow_array())
{ if($no<=2){ $bg=$colcolor; }
  else { $bg="#dddddd"; }
  
  if($no==2){ $lama = $rec[1]; }
  $dt1 = genfuncpyl::mdytodmy($rec[2]);
  $dt2 = genfuncpyl::mdytodmy($rec[3]);
  $jml = genfuncpyl::ribuan($rec[1]);
  print qq~<tr bgcolor=$bg>
    <td align='center' class="hurufcol">$no</td>
    <td align='center' class="hurufcol">$rec[0]</td>
    <td align='right' class="hurufcol">$jml</td>
    <td align='center' class="hurufcol">$dt1</td>
    <td align='center' class="hurufcol">$dt2</td>
  </tr>
  ~;
  $no++;
}
print qq ~ </table>
 <br/>&nbsp;  <br/>
~;

if($in{s3s11} eq 'S')
{
print qq~
<h2 class="hurufcol">UBAH SIMPANAN SUKARELA </h2>
<form action="/cgi-bin/kopbox.cgi" method="post" name='vq'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=idlama value="$in{idlama}">
  <input type=hidden name=lama value=$lama>
  <input type=hidden name=display value=kop004d>
<table width='500px' border='0' cellspacing='2' cellpadding='2'>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"  width=200> &nbsp; Jumlah Simpanan Lama  </td>
    <td class="hurufcol"  bgcolor=$colcolor2> <input type=text name=sk id=sk value="$lama" class=huruf1 size=10 disabled style="text-align: right"></td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" > &nbsp; Jumlah Simpanan Baru  </td>
    <td class="hurufcol"  bgcolor=$colcolor2> <input type=text name=sukarela id=sukarela value="$in{sukarela}" class=huruf1 size=10 maxlength="7" style="text-align: right"></td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" > &nbsp; Tgl Berlaku </td>
    <td class="hurufcol"  bgcolor=$colcolor2> <input class='huruf1' name="dtberlaku" type="text" id="dtberlaku" size="12" maxlength="12" value="$in{dtberlaku}"   onChange="hitungDurasi()"/>
       <img src="/jscalendar/img.gif" id="trigger3" style="cursor: pointer; border: 1px solid blue;" title="Date selector" onMouseOver="this.style.background='blue';" onMouseOut="this.style.background=''" />
       <script type="text/javascript">
       Calendar.setup(
       {
        inputField  : "dtberlaku",         // ID of the input field
        ifFormat    : "%m/%d/%Y",    // the date format
        button      : "trigger3"       // ID of the button
	  //daFormat  :  "%Y/%m/%d"
        }
       );
       </script></td>
  </tr>
  <tr height=20>
    <td colspan=2 align=center><input type='submit' name='simpan' value='Simpan'> </td>
  </tr>
</table>

</form>~;
}

print qq ~ </table>
    <hr width="100" />
</center>
~;
}

;
1

