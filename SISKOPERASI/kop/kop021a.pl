sub kop021a {

genfunckop::view_header_kop($in{ss}, $s3s[2], 'Daftar Pinjaman', $s3s[17]);
genfunckop::validasi_akses_kop($s3s[11], $in{ss});
&koneksi_kop2;
$bgbunga2 = "#c9f7ad";
$bgbunga = "#bfe8a7";
$bgbungadark = "#a9e884";

($month,$day,$year,$weekday) = &jdate(&today());
$month = substr "0$month",-2;
$minprid=$year."-01";
if(!$in{periode}){ $in{periode}=$year."-".$month; }

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
      <input type="submit" name="back" value="Back" class="huruf1"/>
      <input name="pages" type="hidden" value=kop021>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
     </td>
     <td align=center> <h2 class="hurufcol">DAFTAR PINJAMAN</h2> </td>
     <td align=left width=120>
     &nbsp; </td>
     </tr>
     </table>

<form action="/cgi-bin/siskop.cgi" method="post" name='vq'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=kop021a>
<table>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> &nbsp; Periode </td>
    <td class="hurufcol" ><select name="periode" class="huruf1" id="periode">
    ~;
$query = $dbk->prepare("select distinct recid from periode where recid >= '$minprid' order by recid desc  ");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $selected="";
   if ($in{periode} eq $rec[0]) { $selected="selected"; }
   print qq~<option value='$rec[0]' $selected> $rec[0] </option>~;
}
print qq~
    </select>
    </td>
    <td><input type='submit' name='view' value='Go'> </td>
  </tr>
</table>
</form>    ~;

print qq~
<script>
function toBatal(p)
{ var result = confirm("Yakin Batalkan Gerak Staf Yang Sudah Diproses ?");
        if (result==true)
        {
          with(document.pnj)
          { pages.value='kop021a';
            pidbatal.value = p;
            submit();
          }
        }
}
</script>
~;

if($in{pidbatal})
{
   $q1 = $dbk->do("update angsuran set batal='Y', oprupdate='$s3s[0]' where pinjaman_id='$in{pidbatal}' ");
   $q2 = $dbk->do("update pinjaman set batal='Y', oprupdate='$s3s[0]' where recid='$in{pidbatal}' ");
   if($q1!=0 and $q2!=0){ print qq~<div class=warning_ok>Sukses Batalkan Pinjaman </div>~; }
   else { print qq~<div class=warning_not_ok>Gagal Batalkan Pinjaman (1=$q1 2=$q2) </div>~; }

}

print qq~
<form action="/cgi-bin/siskop.cgi" method="post" name="pnj">
  <input type=hidden name=ss value="$in{ss}">
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <input type=hidden name=pages value='kop021a'>
  <input type=hidden name=pidbatal >
  <input type=hidden name=periode value="$in{periode}">

  <table width='1200px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" width=50><b>No.</b></td>
   <td align='center' class="hurufcol" width=100> <b>Cabang</b></td>
   <td align='center' class="hurufcol" width=80> <b>NIK</b></td>
   <td align='center' class="hurufcol" width=100> <b>Nama Peminjam</b> </td>
   <td align='center' class="hurufcol" width=80> <b> Status Kerja</b></td>
   <td align='center' class="hurufcol" width=80> <b> Tgl Pengajuan</b></td>
   <td align='center' class="hurufcol" width=80> <b> Jumlah Pinjaman</b></td>
   <td align='center' class="hurufcol" width=50> <b> Masa Cicil</b></td>
   <td align='center' class="hurufcol" width=80> <b> Lunas</b></td>
   <td align='center' class="hurufcol" width=80> <b> Action</b></td>
  </tr>
~;

$subq="";
if ($in{periode}) { $subq=" AND periode='$in{periode}' "; }

$q = $dbk->prepare("select  kodecabang, namastore, nik, nlengkap, a.idlama, a.statuskerja, dtpengajuan, jmlpengajuan, masacicil, lunas, pridlunas, a.recid
from pinjaman a, getkry k where a.idlama=k.idlama and a.batal='N'  $subq order by nlengkap");
print  "select  kodecabang, namastore, nik, nlengkap, a.idlama, a.statuskerja, dtpengajuan, jmlpengajuan, masacicil, lunas, pridlunas, a.recid
from pinjaman a, getkry k where a.idlama=k.idlama and a.batal='N'  $subq order by nlengkap";
$q->execute();
$no=1;  $totalpinjam=0;
while (@row = $q->fetchrow_array())
{ $btn="";
  $q2 = $dbk2->prepare("select count(*) from angsuran where pinjaman_id=$row[11] and batal='N' and jmlbayar!=0 ");
  $q2->execute();
  @row2=$q2->fetchrow_array();
  if($s3s[11] eq 'S'  and $row2[0]==0)
  {
   $btn.="<input type='image' src='/images/del.png' name='del$no' value='Delete' class='huruf1'
         onClick=\"toBatal('$row[11]');\">";
  }

  $dtstart = genfuncpyl::mdytodmy($row[6]);
  if($row[9] eq 'Y'){ $bg="#ddd"; $bg2="#eee"; }
  elsif($no%2==0) { $bg=$colcolor; $bg2=$bgbunga; }
  else { $bg=$colcolor2;  $bg2=$bgbunga2; }
  
  $jml = genfuncpyl::ribuan($row[7]);
  print qq~
  <tr bgcolor=$bg height=20>
     <td align='center' class="hurufcol" valign="top">$no.</td>
     <td class="hurufcol" valign="top">$row[0]-$row[1]</td>
     <td align='center' class="hurufcol" valign="top">$row[2]</td>
     <td class="hurufcol" valign="top"><a class='iframe' href='/cgi-bin/kopbox.cgi?display=kop021p&pid=$row[11]&ss=$in{ss}'>$row[3]</a></td>
     <td align='center' class="hurufcol" valign="top">$row[5]</td>
     <td align='right' class="hurufcol" valign="top">$dtstart</td>
     <td align='right' class="hurufcol" valign="top">$jml</td>
     <td align='center' class="hurufcol" valign="top">$row[8]</td>
     <td align='center' class="hurufcol" valign="top">$row[9] ($row[10])</td>
     <td align='center' class="hurufcol" valign="top">$btn</td>
   </tr>
   ~;

  $no++;
  $totalpinjam+=$row[7];
}

  $txttotal = genfuncpyl::ribuan($totalpinjam);
  print qq~
  <tr bgcolor=$dark height=20>
     <td align='center' class="hurufcol" colspan=6><b>TOTAL</b></td>
     <td align='right' class="hurufcol" valign="top"><b>$txttotal</b></td>
     <td align='right' class="hurufcol" width=50>&nbsp;</td>
     <td align='right' class="hurufcol" width=50>&nbsp;</td>
     <td align='right' class="hurufcol" width=50>&nbsp;</td>
  </tr>
  </table>
</form>   ~;

print qq ~
    <hr width="100" />
</center>
~;
}

;
1

