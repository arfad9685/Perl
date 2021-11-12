sub kop025k {

use HTML::HTMLDoc;
genfunckop::validasi_akses_kop($s3s[11], $in{ss});
$bgsukarela2 = "#c9f7ad";
$bgsukarela = "#bfe8a7";
$bgsukareladark = "#a9e884";

($month,$day,$year,$weekday) = &jdate(&today());
$month = substr "0$month",-2;
$periodenow = $year."-".$month;
if(!$in{tahun}){ $in{tahun}=$year;  }

$query = $dbk->prepare("select kodecabang, namastore, nik, nlengkap, dtjoin, a.idlama from anggota a, getkry k
where a.idlama=k.idlama and a.idlama=$in{idlama}
");
$query->execute();
@record = $query->fetchrow_array();
$dtberlaku = genfuncpyl::mdytodmy($record[4]);
$idlama = $record[5];
if(!$in{nikgo}){ $in{nikgo}=$record[2]; }

print qq~  <br/> &nbsp; <br/>
<form action="/cgi-bin/kopbox.cgi" method="post" name='vq'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=display value=kop025k>
  <input type=hidden name=idlama value=$in{idlama}>
  <input type=hidden name=tahun value=$in{tahun}>
  <input type=hidden name=nikgo value=$in{nikgo}>
  <input type='submit' name='print' value='Print'>  <br/> &nbsp;<br/>
</form>
~;

print qq~
        <br/> &nbsp;<br/>
     <table width=100% border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=150>
     &nbsp;
     </td>
     <td align=center> <h2 class="hurufcol"> KARTU IURAN</h2> </td>
     <td align=left width=150> &nbsp; </td>
     </tr>
     </table>
     <br/> ~;

$isi =  qq~
<table width='700px' border='0' cellspacing='2' cellpadding='2'>
  <tr height=20>
    <td class="hurufcol" width=150> &nbsp; Karyawan </td>
    <td class="hurufcol"> $record[2] - $record[3] </td>
  </tr>
  <tr height=20>
    <td class="hurufcol" width=150> &nbsp; Cabang </td>
    <td class="hurufcol"> $record[0] - $record[1] </td>
  </tr>
  <tr height=20>
    <td class="hurufcol" width=150> &nbsp; Tgl Join  </td>
    <td class="hurufcol"> $dtberlaku </td>
  </tr>
</table>

  <table width='700px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" rowspan=2 bgcolor="$bgsukareladark"> <b>PERIODE</b> </td>
   <td align='center' class="hurufcol" colspan=4> <b>SIMPANAN</b> </td>
   <td align='center' class="hurufcol" colspan=3> <b>PINJAMAN</b> </td>
   <td align='center' class="hurufcol" rowspan=2 width=80 bgcolor="$bgsukareladark"> <b>TOTAL BAYAR</b> </td>
  </tr>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" width=75 bgcolor="$bgsukareladark"> <b>Pokok</b></td>
   <td align='center' class="hurufcol" width=75 bgcolor="$bgsukareladark"> <b>Sukarela</b> </td>
   <td align='center' class="hurufcol" width=75> <b>Saldo Pokok</b> </td>
   <td align='center' class="hurufcol" width=75> <b>Saldo Sukarela</b> </td>
   <td align='center' class="hurufcol" width=75 bgcolor="$bgsukareladark"> <b>Angsuran</b></td>
   <td align='center' class="hurufcol" width=75 bgcolor="$bgsukareladark"> <b>Bunga</b> </td>
   <td align='center' class="hurufcol" width=75> <b>Saldo Pinjaman</b> </td>
  </tr>~;

$query = $dbk->prepare("select jenis, sum(hrsbayar) from iuran where idlama= $idlama and periode<'$in{tahun}' group by jenis order by jenis");
$query->execute();
while(@rec = $query->fetchrow_array())
{ if($rec[0] eq 'P'){ $totalp=$rec[1]; }
  elsif($rec[0] eq 'S'){ $totals=$rec[1]; }
}

$query = $dbk->prepare("select sum(hrsbayar), sum(bunga) from pinjaman p, angsuran a
where p.recid=a.pinjaman_id and idlama=$idlama  and a.periode < '$in{tahun}'");
$query->execute();
@rec = $query->fetchrow_array();
$totalpinj = $rec[0]+$rec[1];

$txttotalp=genfuncpyl::ribuan($totalp);
$txttotals=genfuncpyl::ribuan($totals);
$txttotalpinj=genfuncpyl::ribuan($totalpinj);
$isi .= qq~
  <tr bgcolor="$colcolor2">
   <td align='center' class="hurufcol">Saldo</td>
   <td align='center' class="hurufcol"  bgcolor="$colcolor3">&nbsp;</td>
   <td align='center' class="hurufcol"  bgcolor="$colcolor3">&nbsp;</td>
   <td align='right' class="hurufcol">$txttotalp</td>
   <td align='right' class="hurufcol">$txttotals</td>
   <td align='center' class="hurufcol"  bgcolor="$colcolor3">&nbsp;</td>
   <td align='center' class="hurufcol"  bgcolor="$colcolor3">&nbsp;</td>
   <td align='right' class="hurufcol">$txttotalpinj</td>
   <td align='center' class="hurufcol" >&nbsp;</td>
  </tr>
~;

$query = $dbk->prepare("select p.recid, i.periode, jenis, i.hrsbayar, x.hrsbayar, x.bunga, i.pencairanid from periode p
left outer join iuran i on p.recid=i.periode and idlama=$idlama and i.periode >='$in{tahun}-01' and i.periode<='$in{tahun}-12'
left outer join (select a.periode, hrsbayar, bunga from pinjaman p, angsuran a
where p.recid=a.pinjaman_id and idlama=$idlama  and a.periode >='$in{tahun}-01' and a.periode<='$in{tahun}-12' and a.periode <='$periodenow' and batal='N') x
on p.recid=x.periode
where p.recid >='$in{tahun}-01'  and p.recid<='$in{tahun}-12' ");
$query->execute(); $no=1; $totalrow=0; $flag=0;
while(@rec = $query->fetchrow_array())
{ if($no%2==1){ $bg=$colcolor; }
  else { $bg=$colcolor2; }
  
  if($tmp ne $rec[0])
  {
    $pokok = genfuncpyl::ribuan($rec[3]);
    $totalp+=$rec[3];
    $totalrow=$rec[3];
    if($no%2==0) {  $bg2=$bgsukarela2; }
    else {   $bg2=$bgsukarela; }
    
    $bgs = $bg2;
    if($rec[6]) { $bgs = "coral";}

    if($flag==1)
    {   $isi .= qq~
     <td align='right' class="hurufcol"  bgcolor="$tmpbg" >&nbsp; </td>
     <td align='right' class="hurufcol">&nbsp; </td>
     <td align='right' class="hurufcol">&nbsp; </td>
     <td align='right' class="hurufcol"  bgcolor="$tmpbg2">&nbsp; </td>
     <td align='right' class="hurufcol"  bgcolor="$tmpbg2">&nbsp; </td>
     <td align='right' class="hurufcol">&nbsp; </td>
     <td align='right' class="hurufcol">&nbsp; </td>
    </tr>~;
    }

    $isi .= qq~<tr bgcolor=$bg>
     <td align='center' class="hurufcol">$rec[0]</td>
     <td align='right' class="hurufcol"  bgcolor="$bgs">$pokok</td>
    ~;
    $no++;
    $flag=1;
  }
  else
  { $totals+=$rec[3];
    $totalrow+=$rec[3];

    if($rec[4])
    { $totalpinj+=($rec[4]+$rec[5]);
      $totalrow+=($rec[4]+$rec[5]);
      $angsuran = genfuncpyl::ribuan($rec[4]);
      $bunga = genfuncpyl::ribuan($rec[5]);
      $txttotalpinj=genfuncpyl::ribuan($totalpinj);
    }
    else
    { $angsuran=0; $bunga=0; $txttotalpinj=0; }

    $bgs = $bg2;
    if($rec[6]) { $bgs = "coral";}

    $sukarela = genfuncpyl::ribuan($rec[3]);
    $txttotalp=genfuncpyl::ribuan($totalp);
    $txttotals=genfuncpyl::ribuan($totals);
    $txttotalrow=genfuncpyl::ribuan($totalrow);
    $isi .= qq~
     <td align='right' class="hurufcol"  bgcolor="$bgs" >$sukarela</td>
     <td align='right' class="hurufcol">$txttotalp</td>
     <td align='right' class="hurufcol">$txttotals</td>
     <td align='right' class="hurufcol"  bgcolor="$bg2">$angsuran</td>
     <td align='right' class="hurufcol"  bgcolor="$bg2">$bunga</td>
     <td align='right' class="hurufcol">$txttotalpinj</td>
     <td align='right' class="hurufcol">$txttotalrow</td>
    </tr>~;
    $flag=2;

  }

  $tmpbg=$bgs;
  $tmpbg2=$bg2;

  $tmp=$rec[0];
}

if($flag==1)
{   $isi .= qq~
     <td align='right' class="hurufcol"  bgcolor="$tmpbg" >&nbsp; </td>
     <td align='right' class="hurufcol">&nbsp; </td>
     <td align='right' class="hurufcol">&nbsp; </td>
     <td align='right' class="hurufcol"  bgcolor="$tmpbg2">&nbsp; </td>
     <td align='right' class="hurufcol"  bgcolor="$tmpbg2">&nbsp; </td>
     <td align='right' class="hurufcol">&nbsp; </td>
     <td align='right' class="hurufcol">&nbsp; </td>
    </tr>~;
}

$isi .= qq~ </table>
Note : Warna Merah Berarti Sudah dicairkan ~;

if($in{print})
{        my $htmldoc = new HTML::HTMLDoc('mode'=>'file');
        $htmldoc->set_html_content(qq|
        <!DOCTYPE >
        <html>
        <head></head>
        <body>
        <h2 class="hurufcol"> KARTU IURAN KOPERASI</h2> <br/> $isi
        </body>
        </html>
        |);

        $htmldoc->portrait();
        $htmldoc->set_page_size("A4");
        $htmldoc->landscape();
        $htmldoc->set_bodyfont('Arial'); # set font
        $htmldoc->set_fontsize('10'); # set font
        $htmldoc->set_left_margin(1, 'cm'); # set margin
        $htmldoc->set_right_margin(1, 'cm'); # set margin
        $htmldoc->set_bottom_margin(1, 'cm'); # set margin
        $htmldoc->set_top_margin(1, 'cm'); # set margin
        $htmldoc->title('KARTU IURAN');
        $htmldoc->set_footer('/', '.', 'D');
        my $pdf = $htmldoc->generate_pdf();

        $direktori='/home/sarirasa/htdocs/download/k4127u/';
        $namafile=$in{nikgo}.'_'.$in{tahun}.'.pdf';
        $temppdf=$direktori.$namafile;
        $flag = $pdf->to_file($direktori.$namafile);

          if (-e $temppdf)
          { print qq~
            <script>
            //doesn't block the load event
            function createIframe(){
              var i = document.createElement("iframe");
              i.src = "http://172.16.11.12/download/k4127u/$namafile";
              i.scrolling = "auto";
              i.frameborder = "0";
              i.width = "1000px";
              i.height = "600px";
              document.getElementById("ifr").appendChild(i);
            };

            // Check for browser support of event handling capability
            if (window.addEventListener)
            window.addEventListener("load", createIframe, false);
            else if (window.attachEvent)
            window.attachEvent("onload", createIframe);
            else window.onload = createIframe;

            </script>
            <div id='ifr'>
                </div>
                <br/><br/>~;

         }
         else
         { print qq~<br/> File tidak tersedia <br/> ~;
         }
}
else
{ print $isi;
}

print qq~
    <hr width="100" />
</center>
~;
}

;
1

