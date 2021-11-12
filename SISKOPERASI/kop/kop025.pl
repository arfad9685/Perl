sub kop025 {

genfunckop::view_header_kop($in{ss}, $s3s[2], 'Iuran Cabang', $s3s[17]);
genfunckop::validasi_akses_kop($s3s[11], $in{ss});
&koneksi_kop2;
$bgsukarela2 = "#c9f7ad";
$bgsukarela = "#bfe8a7";
$bgsukareladark = "#a9e884";

($month,$day,$year,$weekday) = &jdate(&today());
if(!$in{tahun}){ $in{tahun}=$year; }

$query = $dbp->prepare("select department from X0000003 where namausr='$s3s[0]'");
$query->execute();
@rec = $query->fetchrow_array();
$divid = $rec[0];
if($s3s[0] eq 'XTIN') { $divid='HO'; }

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
      width:"1200px",
      height:"98%"});

    \$("#click").click(function(){
	 \$(".iframe").colorbox.close();
    });
});
</script>

     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=100>
     &nbsp;
     </td>
     <td align=center> <h2 class="hurufcol"> IURAN CABANG</h2> </td>
     &nbsp;
     </tr>
     </table>

<form action="/cgi-bin/siskop.cgi" method="post" name='vq'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=kop025>
<table>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> &nbsp; Tahun </td>
    <td class="hurufcol" ><select name="tahun" class="huruf1" id="tahun">
    ~;
($month,$day,$year,$weekday) = &jdate(&today());
for ($i=2017; $i<=$year; $i++)
{  $selected="";
   if ($in{tahun}==$i) { $selected="selected"; }
   print qq~<option value='$i' $selected> $i </option>~;
}
print qq~
    </select>
    </td>
    <td class="hurufcol" width=100> &nbsp; Cabang </td>
    <td class="hurufcol" ><select name="cabang" class="huruf1" id="cabang">
    <option value=''>ALL</option>~;
$query = $dbk->prepare("select distinct kodecabang, namastore from anggota a, getkry k
where a.idlama=k.idlama and k.divid='$divid' order by kodecabang");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $selected="";
   if ($in{cabang} eq $rec[0]) { $selected="selected"; }
   print qq~<option value='$rec[0]' $selected> $rec[0] - $rec[1] </option>~;
}
print qq~
    </select>
    </td>
    <td><input type='submit' name='view' value='Go'> </td>
  </tr>
</table>
</form>    ~;

print qq~
  <table width='1200px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" width=50 rowspan=2><b>No.</b></td>
   <td align='center' class="hurufcol" width=100 rowspan=2> <b>NIK</b></td>
   <td align='center' class="hurufcol" width=220 rowspan=2> <b>Nama Anggota</b> </td>
   <td align='center' class="hurufcol" width=50 rowspan=2> <b> Pokok</b></td>
   <td align='center' class="hurufcol" width=50 rowspan=2 bgcolor=$bgsukareladark> <b> Sukarela</b></td>~;
for ($i=1; $i<=12; $i++)
{ $bulan = genfuncpyl::format_bulan2($i);
  $bulan = substr $bulan,0,3;
  print qq~<td colspan=2 align='center' class="hurufcol" ><b> $bulan </b></td>~;
}
print qq~
   <td align='center' class="hurufcol" width=50 rowspan=2> <b> TotalP</b></td>
   <td align='center' class="hurufcol" width=50 rowspan=2 bgcolor=$bgsukareladark> <b> TotalS</b></td>
  </tr>
   <tr bgcolor="$dark">
~;
for ($i=1; $i<=12; $i++)
{ $totalblnp[$i]=0;
  $totalblns[$i]=0;
  print qq~<td align='center' class="hurufcol" width=50><b>P</b></td>
           <td align='center' class="hurufcol" width=50 bgcolor=$bgsukarela><b>S</b></td>~;
}
print qq~  </tr>~;

$subq="";
if ($in{cabang}) { $subq=" AND kodecabang='$in{cabang}' "; }

$q = $dbk->prepare("select nik, nlengkap, a.idlama, kodecabang from anggota a, getkry k
where a.idlama=k.idlama and extract(year from dtjoin)<=$in{tahun} and k.divid='$divid' and a.aktif='Y' $subq order by nlengkap");
$q->execute();
$no=1;
$tmpcab='';  $totalp=0; $totals=0;
while (@row = $q->fetchrow_array())
{
#  if ($tmpcab and $tmpcab ne $row[3]) { print qq~<tr bgcolor=$dark height=5><td colspan=7></td> </tr>~; }
  $pokok=0; $sukarela=0;
  $q2 = $dbk2->prepare("select jumlah/1000 from simpanan where idlama = $row[2]
        and dtberlaku<='12/31/$in{tahun}' and '12/31/$in{tahun}'<=dtexpired  order by jenis, dtexpired rows 1 to 2");
  $q2->execute();
  $i=1;
  while (@row2 = $q2->fetchrow_array())
  { if($i==1){ $pokok=$row2[0]; }
    else { $sukarela=$row2[0]; }
    $i++;
  }

  if($no%2==0) { $bg=$colcolor; $bg2=$bgsukarela; }
  else { $bg=$colcolor2;  $bg2=$bgsukarela2; }
    print qq~
  <tr bgcolor=$bg height=20>
     <td align='center' class="hurufcol" valign="top">$no.</td>
     <td align='center' class="hurufcol" valign="top">$row[0]</td>
     <td class="hurufcol" valign="top"><a class='iframe' href='/cgi-bin/kopbox.cgi?display=kop025k&tahun=$in{tahun}&tahun2=$in{tahun}&idlama=$row[2]&ss=$in{ss}'>$row[1]</a></td>
     <td align='right' class="hurufcol" valign="top">$pokok</td>
     <td align='right' class="hurufcol" valign="top" bgcolor=$bg2>$sukarela</td>
   ~;
  $q2 = $dbk2->prepare("select jmlbayar/1000, jenis, periode, pencairanid from iuran  where idlama = $row[2] and periode like '$in{tahun}%'
        order by periode, jenis");
  $q2->execute();
  $totalorgp=0; $totalorgs=0; $ctrb=1;  $b=0;
  while (@row2 = $q2->fetchrow_array())
  {
#     if($totalorgp==0 and $row2[2] ne "$in{tahun}-01")
#     {  $bulanstart = substr $row2[2],5,2;
#        $bulanstart = $bulanstart-0;
#        #for ($i=1; $i<=($bulanstart-1); $i++){ print qq~<td class="hurufcol">&nbsp;</td><td class="hurufcol" bgcolor=$bg2>&nbsp;</td>~; }
#        $ctrb = $bulanstart;
#     }
  
     $b = substr $row2[2],5,2;   $b = $b-0;
     if($ctrb!=$b)
     { for ($i=$ctrb; $i<=($b-1); $i++){ print qq~<td class="hurufcol">&nbsp;</td><td class="hurufcol" bgcolor=$bg2>&nbsp;</td>~; }
       $ctrb = $b;
     }
     
     if($row2[1] eq 'P')
     { $totalorgp+=$row2[0];  $totalblnp[$b]+=$row2[0];  $bgkolom=" ";
       if($row2[3]){  $bgkolom="bgcolor=#F3F781"; }
     }
     else
     { $totalorgs+=$row2[0]; $totalblns[$b]+=$row2[0]; $bgkolom=" bgcolor=$bg2"; $ctrb++;
       if($row2[3]){  $bgkolom="bgcolor=#F2F5A9"; }
     }
     
     print qq~<td align='right' class="hurufcol" valign="top" $bgkolom>$row2[0]</td>~;

  }

  if($b!=12)
  {  for ($i=$b+1; $i<=12; $i++){ print qq~<td class="hurufcol">&nbsp;</td><td class="hurufcol" bgcolor=$bg2>&nbsp;</td>~; }
  }

  print qq~
     <td align='right' class="hurufcol" valign="top"><b>$totalorgp</b></td>
     <td align='right' class="hurufcol" valign="top" bgcolor=$bg2><b>$totalorgs</b></td>
  </tr> ~;
   
  $no++;
  $totalp+=$pokok;
  $totals+=$sukarela;

  $tmpcab=$row[3];
}

    print qq~
  <tr bgcolor=$dark height=20>
     <td align='left' class="hurufcol" colspan=3><b>TOTAL</b></td>
     <td align='right' class="hurufcol" valign="top"><b>$totalp</b></td>
     <td align='right' class="hurufcol" valign="top" bgcolor=$bgsukareladark><b>$totals</b></td> ~;
$totalallp=0; $totalalls=0;
for ($i=1; $i<=12; $i++)
{ $totalallp+=$totalblnp[$i];
  $totalalls+=$totalblns[$i];
  print qq~<td align='right' class="hurufcol" width=50>$totalblnp[$i]</td>
           <td align='right' class="hurufcol" width=50 bgcolor=$bgsukareladark>$totalblns[$i]</td>~;
}

  print qq~ <td align='right' class="hurufcol" valign="top"><b>$totalallp</b></td>
     <td align='right' class="hurufcol" valign="top" bgcolor=$bgsukareladark><b>$totalalls</b></td>
  </tr>
  </table>  ~;

print qq ~  Note : Warna Kuning Berarti Sudah dicairkan
    <hr width="100" />
</center>
~;
}

;
1

