sub kop020 {

use Spreadsheet::WriteExcel;
genfunckop::view_header_kop($in{ss}, $s3s[2], 'Iuran', $s3s[17]);
genfunckop::validasi_akses_kop($s3s[11], $in{ss});
&koneksi_kop2;
$bgsukarela2 = "#c9f7ad";
$bgsukarela = "#bfe8a7";
$bgsukareladark = "#a9e884";
@aktif = ("Y", "N");
if(!$in{vaktif}){ $in{vaktif}="Y"; }

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
     <td align=center> <h2 class="hurufcol"> IURAN</h2> </td>
     ~;
if ($s3s[11] eq 'S')
{     print qq~
      <!--<td align=right width=50><form method=post action="/cgi-bin/siskop.cgi" >
      <input type="submit" name="back" value="Generate Iuran" class="huruf1"/>
      <input name="pages" type="hidden" value=kop020g>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
      </td>-->
       <td align=right width=50><form method=post action="/cgi-bin/siskop.cgi" >
      <input type="submit" name="back" value="Bayar Manual" class="huruf1"/>
      <input name="pages" type="hidden" value=kop020m>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
      </td>
       ~;
}     print qq~
     </tr>
     </table>

<form action="/cgi-bin/siskop.cgi" method="post" name='vq'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=kop020>
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
print qq~ </td>
  </tr>
</table>
</form>    ~;

if($in{export})
{
  @kolom = ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'AA', 'AB', 'AC', 'AD', 'AE', 'AF', 'AG', 'AH', 'AI', 'AJ', 'AK', 'AL', 'AM', 'AN', 'AO', 'AP', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AV', 'AW', 'AX', 'AY', 'AZ', 'BA', 'BB', 'BC', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BK', 'BL', 'BM', 'BN', 'BO', 'BP', 'BQ', 'BR', 'BS', 'BT', 'BU', 'BV', 'BW', 'BX', 'BY', 'BZ', 'CA', 'CB', 'CC', 'CD', 'CE', 'CF', 'CG', 'CH', 'CI', 'CJ', 'CK', 'CL', 'CM', 'CN', 'CO', 'CP', 'CQ', 'CR', 'CS', 'CT', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DA', 'DB', 'DC', 'DD', 'DE', 'DF', 'DG', 'DH', 'DI', 'DJ', 'DK', 'DL', 'DM', 'DN', 'DO', 'DP', 'DQ', 'DR');
  $temp01="/home/$folder_user/htdocs/tmpkop/Iuran_$in{tahun}_".$year.$month.$day.".xls";
  $temp02="Iuran_$in{tahun}_".$year.$month.$day.'.xls';

  my $workbook  = Spreadsheet::WriteExcel->new($temp01);
  my $worksheet = $workbook->add_worksheet();

  my $bold = $workbook->addformat();
  $bold->set_bold();
  $bold->set_size('11');
  my $mboldcenter = $workbook->addformat();
  $mboldcenter->set_align('center');
  $mboldcenter->set_bold();
  $mboldcenter->set_size('11');
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

  $worksheet->set_column(0, 0, 3);
  $worksheet->set_column(1, 1, 10);
  $worksheet->set_column(2, 2, 30);
  $worksheet->set_column(3, 4, 10);
  $worksheet->set_column(5, 28, 6);
  $worksheet->set_column(29, 30, 8);
  $worksheet->set_column(31, 32, 14);

  $worksheet->write(0, 0,  "No.", $boldcenter);
  $worksheet->write(0, 1,  "NIK", $boldcenter);
  $worksheet->write(0, 2,  "Nama", $boldcenter);
  $worksheet->write(0, 3,  "Pokok", $boldcenter);
  $worksheet->write(0, 4,  "Sukarela",$boldcenter);
  for ($i=1, $f=5, $g=6; $i<=12; $i++, $f+=2, $g+=2)
  { $bulan = genfuncpyl::format_bulan2($i);
    $bulan = substr $bulan,0,3;
    $worksheet->merge_range("$kolom[$f]1:$kolom[$g]1", $bulan, $mboldcenter);
    $worksheet->write(1, $f,  "P",$boldcenter);
    $worksheet->write(1, $g,  "S",$boldcenter);
  }
  $worksheet->write(0, 29,  "TotalP",$boldcenter);
  $worksheet->write(0, 30,  "TotalS",$boldcenter);
  $worksheet->write(0, 31,  "Grand TotalP",$boldcenter);
  $worksheet->write(0, 32,  "Grand TotalS",$boldcenter);

  $subq="";
  if ($in{cabang}) { $subq=" AND kodecabang='$in{cabang}' "; }
  if ($in{vaktif}) { $subq=" AND a.aktif='$in{vaktif}' "; }

  $q = $dbk->prepare("select nik, nlengkap, a.idlama, kodecabang from anggota a, getkry k
  where a.idlama=k.idlama and extract(year from dtjoin)<=$in{tahun} $subq order by nlengkap");
  $q->execute();
  $no=1; $baris=2;
  $tmpcab='';  $totalp=0; $totals=0;  $gtp=0; $gts=0;
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

    $worksheet->write($baris, 0,  "$no.");
    $worksheet->write($baris, 1,  "$row[0]");
    $worksheet->write($baris, 2,  "$row[1]");
    $worksheet->write($baris, 3,  "$pokok");
    $worksheet->write($baris, 4,  "$sukarela", $grey);

    $q2 = $dbk2->prepare("select jmlbayar/1000, jenis, periode, pencairanid from iuran  where idlama = $row[2] and periode like '$in{tahun}%'
        order by periode, jenis");
    $q2->execute();   $kolom=5;
    $totalorgp=0; $totalorgs=0; $ctrb=1;  $b=0;
    while (@row2 = $q2->fetchrow_array())
    {
      $b = substr $row2[2],5,2;   $b = $b-0;
      if($ctrb!=$b)
      { for ($i=$ctrb; $i<=($b-1); $i++){ $kolom+=2; }
        $ctrb = $b;
      }

      $ketcair="";
      if($row2[1] eq 'P')
      { $totalorgp+=$row2[0];  $totalblnp[$b]+=$row2[0];  $format="";
        if($row2[3]){  $ketcair="*"; }
      }
      else
      { $totalorgs+=$row2[0]; $totalblns[$b]+=$row2[0]; $format=$grey; $ctrb++;
        if($row2[3]){  $ketcair="*"; }
      }
      $worksheet->write($baris, $kolom,  "$row2[0]$ketcair", $format);
      $kolom++;
    }

    $worksheet->write($baris, 29,  "$totalorgp", $boldr); $kolom++;
    $worksheet->write($baris, 30,  "$totalorgs", $boldrgrey); $kolom++;

    if($in{tahun} eq $year)
    {
      $q2 = $dbk2->prepare("select jenis, sum(jmlbayar/1000)  from iuran  where idlama = $row[2] and pencairanid is null
        group by jenis order by jenis");
      $q2->execute(); $ctrgt=1;  $addbg="";
      while (@row2 = $q2->fetchrow_array())
      {  if($ctrgt==2){ $format=$boldrgrey; $gts+=$row2[1]; $kolom=32;}
         else { $format=$boldr;  $gtp+=$row2[1]; $kolom=31; }
         $worksheet->write($baris, $kolom,  "$row2[1]", $format); $kolom++;
         $ctrgt++;
      }
      if($ctrgt==1)
      { $worksheet->write($baris, 31,  "0", $boldr); $kolom++;
        $worksheet->write($baris, 32,  "0", $boldrgrey); $kolom++;
      }
    }
    $baris++;

    $no++;
    $totalp+=$pokok;
    $totals+=$sukarela;

    $tmpcab=$row[3];
  }

  $worksheet->write($baris, 0,  "TOTAL", $bold);
  $worksheet->write($baris, 3,  "$totalp", $boldr);
  $worksheet->write($baris, 4,  "$totals", $boldrgrey);

  $totalallp=0; $totalalls=0;
  for ($i=1, $f=5, $g=6; $i<=12; $i++, $f+=2, $g+=2)
  { $totalallp+=$totalblnp[$i];
    $totalalls+=$totalblns[$i];
    $worksheet->write($baris, $f,  "$totalblnp[$i]", $boldr);
    $worksheet->write($baris, $g,  "$totalblns[$i]", $boldrgrey);
  }

  $worksheet->write($baris, 29,  "$totalallp", $boldr);
  $worksheet->write($baris, 30,  "$totalalls", $boldrgrey);
  $worksheet->write($baris, 31,  "$gtp", $boldr);
  $worksheet->write($baris, 32,  "$gts", $boldrgrey);

  print qq~<span class=styleTitle><a href=/tmpkop/$temp02 class='hurufcol'>Download Di Sini</a></span>  <br/> <br/>~;
}

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
~;
if($in{tahun} eq $year)
{ print qq~
   <td align='center' class="hurufcol" width=50 rowspan=2> <b> Grand TotalP</b></td>
   <td align='center' class="hurufcol" width=50 rowspan=2 bgcolor=$bgsukareladark> <b>Grand TotalS</b></td>
  ~;
}
print qq~
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
if ($in{vaktif}) { $subq=" AND a.aktif='$in{vaktif}' "; }

$q = $dbk->prepare("select nik, nlengkap, a.idlama, kodecabang from anggota a, getkry k
where a.idlama=k.idlama and extract(year from dtjoin)<=$in{tahun} $subq order by nlengkap");
$q->execute();
$no=1;
$tmpcab='';  $totalp=0; $totals=0;  $gtp=0; $gts=0;
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
     <td class="hurufcol" valign="top"><a class='iframe' href='/cgi-bin/kopbox.cgi?display=kop020k&tahun=$in{tahun}&tahun2=$in{tahun}&idlama=$row[2]&ss=$in{ss}'>$row[1]</a></td>
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
   ~;
  if($in{tahun} eq $year)
  {
    $q2 = $dbk2->prepare("select jenis, sum(jmlbayar/1000)  from iuran  where idlama = $row[2] and pencairanid is null
        group by jenis order by jenis");
    $q2->execute(); $ctrgt=1;  $addbg="";
    while (@row2 = $q2->fetchrow_array())
    {  if($ctrgt==2){ $addbg="bgcolor=$bg2"; $gts+=$row2[1]; }
       else { $gtp+=$row2[1]; }
       print qq~<td align='right' class="hurufcol" valign="top" $addbg><b>$row2[1]</b></td>~;
       $ctrgt++;
    }
    if($ctrgt==1)
    { print qq~<td align='right' class="hurufcol" valign="top"><b>0</b></td>
     <td align='right' class="hurufcol" valign="top" bgcolor=$bg2><b>0</b></td>~;
    }
  }
  print qq~</tr>~;
  
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
     <td align='right' class="hurufcol" valign="top"><b>$gtp</b></td>
     <td align='right' class="hurufcol" valign="top" bgcolor=$bgsukareladark><b>$gts</b></td>
  </tr>
  </table>  ~;

print qq ~  Note : Warna Kuning Berarti Sudah dicairkan
    <hr width="100" />
</center>
~;
}

;
1

