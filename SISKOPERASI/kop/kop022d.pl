sub kop022d {

use HTML::HTMLDoc;
genfunckop::validasi_akses_kop($s3s[11], $in{ss});
&koneksi_kop2;

print qq~
        <br/> &nbsp;<br/>
     <table width=100% border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=150>
     &nbsp;
     </td>
     <td align=center> <h2 class="hurufcol"> Pencairan Simpanan Detail</h2> </td>
     <td align=left width=150> &nbsp; </td>
     </tr>
     </table>
     <br/>
~;

$query = $dbk2->prepare("select dttransaksi, kodecabang, namastore, nik, nlengkap, kategori, jumlah, keterangan, batal, m.recid, dtlast, dtjoin
     from PENCAIRAN m, getkry k, anggota a where m.idlama=k.idlama and k.idlama=a.idlama
     and m.idlama='$in{idlama}' and m.dttransaksi='$in{dt}' and batal='N' order by kategori
");
$query->execute(); $ctr=1;
while (@record = $query->fetchrow_array())
{ $jml = genfuncpyl::ribuan($record[6]);
  $selipan="";
  if($ctr==1)
  {
    $dtcair = genfuncpyl::mdytodmy($record[0]);
    $dtjoin = genfuncpyl::mdytodmy($record[11]);
    $dtlast="";
    if($record[10]){ $dtlast = genfuncpyl::mdytodmy($record[10]); }
    $namakry = $record[4];
    $isi = qq~
<table width='700px' border='0' cellspacing='2' cellpadding='2'>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"  width=100> &nbsp; Karyawan </td>
    <td class="hurufcol"  bgcolor=$colcolor2> $record[3] - $record[4] </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" > &nbsp; Cabang </td>
    <td class="hurufcol"  bgcolor=$colcolor2> $record[1] - $record[2] </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" > &nbsp; Tgl Join  </td>
    <td class="hurufcol"  bgcolor=$colcolor2> $dtjoin </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" > &nbsp; Tgl Resign  </td>
    <td class="hurufcol"  bgcolor=$colcolor2> $dtlast </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" > &nbsp; Tgl Pencairan  </td>
    <td class="hurufcol"  bgcolor=$colcolor2> $dtcair </td>
  </tr>
</table> ~;
    if($in{print}) { $isi.="Telah disetujui Pencairan Simpanan Anggotanya dengan detail sbb:<br/>  "; }
  $isi .= qq~
<table border=0 cellspacing=5 cellpadding=0 width=530>
    <tr bgcolor=$colcolor height=20>~;
  }
  
  $isi .= qq~ <td valign=top>
  <table width='260' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" colspan=3> <b>$record[5] - $jml ($record[7])</b></td>
  </tr>
    <tr bgcolor="$dark">
   <td align='center' class="hurufcol" width=80><b>No</b></td>
   <td align='center' class="hurufcol" width=80><b>Periode</b></td>
   <td align='center' class="hurufcol" width=100> <b>Iuran $record[5]</b></td>
  </tr>~;

    $q = $dbk->prepare("select periode, hrsbayar from iuran where PENCAIRANid='$record[9]' order by periode");
    $q->execute();
    $no=1;  $total=0;
    while(@rec = $q->fetchrow_array())
    {   if($no%2==1){ $bg=$colcolor; }
        else { $bg=$colcolor2; }

        $jml = genfuncpyl::ribuan($rec[1]);
        $total+=$rec[1] ;
        $isi .= qq~
    <tr bgcolor=$bg>
     <td align='center' class="hurufcol">$no</td>
     <td align='center' class="hurufcol">$rec[0]</td>
     <td align='right' class="hurufcol">$jml</td>
    </tr>
    ~;
        $no++;
    }

    $jml = genfuncpyl::ribuan($total);
    $isi .= qq ~ <tr bgcolor=$dark>
     <td align='right' class="hurufcol" colspan=2><b>TOTAL</b></td>
     <td align='right' class="hurufcol"><b>$jml</b></td>
    </tr>
    </table>
    </td> ~;
    $ctr++;
    
}
$isi .= qq~  </tr>
    </table>
~;
$no--;

if($in{print})
{
  if($no>=23 and $no<=32){ for ($i=1; $i<=10; $i++){ $isi.="<br/> ";} }
  my $htmldoc = new HTML::HTMLDoc('mode'=>'file');
  $htmldoc->set_html_content(qq|
        <!DOCTYPE >
        <html>
        <head></head>
        <body>
        <h2 class=hurufcol>PERSETUJUAN PENCAIRAN SIMPANAN ANGGOTA</h2>
        $isi
        <table width=80% border=0 cellpadding=2 cellspacing=0>
          <tr>
                <td>Tanggal : ___________________<br/>Peminjam,<br/><br/><br/><br/><br/><br/>$namakry </td>
                <td><br/>Bagian Penagihan,<br/><br/><br/><br/><br/><br/>TRIA ROITHO </td>
          </tr>
        </table>
        </body>
        </html>
        |);

  $htmldoc->portrait();
  $htmldoc->set_page_size("A4");
  $htmldoc->set_bodyfont('Arial'); # set font
  $htmldoc->set_fontsize('11'); # set font
  $htmldoc->set_left_margin(1, 'cm'); # set margin
  $htmldoc->set_right_margin(1, 'cm'); # set margin
  $htmldoc->set_bottom_margin(1, 'cm'); # set margin
  $htmldoc->set_top_margin(1, 'cm'); # set margin
  $htmldoc->title('PERSETUJUAN PEMBAYARAN PINJAMAN');
  $htmldoc->set_footer('D', '.', '/');
  my $pdf = $htmldoc->generate_pdf();

  $direktori='/home/sarirasa/htdocs/download/7104/';
  $dt = genfuncpyl::mdytodmy($row[6]);
  $dt=~ s/\///g;
  $namafile=$nik.'_'.$dt.'.pdf';
  $temppdf=$direktori.$namafile;
  $flag = $pdf->to_file($direktori.$namafile);

  if (-e $temppdf)
  { print qq~
            <script>
            //doesn't block the load event
            function createIframe(){
              var i = document.createElement("iframe");
              i.src = "http://172.16.11.12/download/7104/$namafile";
              i.scrolling = "auto";
              i.frameborder = "0";
              i.width = "880px";
              i.height = "700px";
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
{
print qq~ $isi
    <form method=post action="/cgi-bin/kopbox.cgi" >
      <input type="submit" name="print" value="Print" class="huruf1"/>
      <input name="display" type="hidden" value=kop022d>
      <input name="idlama" type="hidden" value=$in{idlama}>
      <input name="dt" type="hidden" value='$in{dt}'>
      <input name="ss" type="hidden" value="$in{ss}">
      </form>
    <hr width="100" />
</center>
~;
}

}

;
1

