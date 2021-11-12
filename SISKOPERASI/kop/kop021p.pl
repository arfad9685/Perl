sub kop021p {

use HTML::HTMLDoc;
use Date::Calc qw(Add_Delta_Days);
genfunckop::validasi_akses_kop($s3s[11], $in{ss});

if($in{lunas})
{ $q1= $dbk->do("update pinjaman set lunas='Y', oprupdate='$s3s[0]' where recid = $in{pid}");
  if($q1!=0){ print qq~<div class=warning_ok>Sukses Lunaskan Pinjaman</div>~; }
  else{ print qq~<div class=warning_not_ok>GAGAL Lunaskan Pinjaman</div>~; }
}

if($in{pid})
{ $q = $dbk->prepare("select nik, nlengkap, a.idlama, kodecabang, jmlapprove, masacicil, dtapprove, recid, lunas, pridlunas from pinjaman a, getkry k
  where a.idlama=k.idlama and a.recid=$in{pid} ");
  $q->execute();
  @row = $q->fetchrow_array();
  $tmpnikgo = $row[0]." - ".$row[1];
  $nik = $row[0];
  $masacicil = $row[5];
  $pridlunas = $row[9];

  $row[6]=genfuncpyl::formatMDY($row[6]);
  $dtpinjam=genfuncpyl::mdytodmy($row[6]);
  ($m,$d,$y)=genfuncpyl::getMdy($row[6]);
  $jmlpinjam = genfuncpyl::ribuan($row[4]);

  $query = $dbk->prepare("select jumlah from simpanan s, getkry k
where s.idlama=k.idlama and  nik='$nik'  and dtexpired='1/1/2099' order by jenis");
  $query->execute();
  $i=0;
  while(@rec = $query->fetchrow_array())
  {  if($i==0){ $pokok = $rec[0]; }
     else { $sukarela=$rec[0]; }
     $i++;
  }
 
  $header = qq~<table width=70% border=0 cellpadding=2 cellspacing=0 align=center>
          <tr class=hurufcol> <td width=150>NIK - Nama Karyawan  </td><td>: $tmpnikgo</td>  </tr>
          <tr class=hurufcol> <td>Tanggal Pinjaman </td><td>: $dtpinjam</td>  </tr>
          <tr class=hurufcol> <td>Jumlah Pinjaman  </td><td>: Rp. $jmlpinjam,-</td>  </tr>
          <tr class=hurufcol> <td>Bunga Pinjaman   </td><td>: 1 %</td>  </tr>
          <tr class=hurufcol> <td>Lama Angsuran   </td><td>: $row[5] bulan</td>  </tr>
          <tr class=hurufcol> <td>Status Lunas   </td><td>: <b>$row[8]</b></td>  </tr>
          <tr class=hurufcol> <td>Periode Lunas   </td><td>: <b>$pridlunas</b></td>  </tr>
        </table>~;
        
  $isi = qq~
  <table width=700 border=1 cellspacing=0 cellpadding=2>
      <tr bgcolor=$dark  class="hurufcol">
        <td align=center><b>No.</b></td>
        <td align=center><b>Bulan Angsuran</b></td>
        <td align=center><b>Pokok</b></td>
        <td align=center><b>Sukarela</b></td>
        <td align=center><b>Angsuran</b></td>
        <td align=center><b>Bunga</b></td>
        <td align=center><b>Total Setoran</b></td>
        <td align=center><b>Sisa<br/>Pinjaman</td>
  ~;
  if(!$in{print})
  { $isi .= qq~<td align=center><b>Denda</b></td>
        <td align=center><b>Jumlah Bayar</b></td>
        <td align=center><b>Tgl Bayar</b></td>~;
  }

  $isi .= qq~  </tr>~;

  $q2 = $dbk->prepare("select periode, hrsbayar, bunga,denda, dtbayar, jmlbayar from angsuran  where pinjaman_id = $row[7]
      and periode like '$in{tahun}%' and batal='N'
        order by periode");
  $q2->execute();
  $totalang=0; $totalbunga=0; $i=1; $totaljmlbyr=0;
  while (@row2 = $q2->fetchrow_array())
  {  if($i%2==0) { $bg=$colcolor;  }
     else { $bg=$colcolor2;   }
     $dtbayar="";
     if($row2[4]) { $row2[4]=genfuncpyl::formatMDY($row2[4]); $dtbayar=genfuncpyl::mdytodmy($row2[4]); }
     
     $txtangsuran =genfuncpyl::ribuan($row2[1]);
     $txtbunga =genfuncpyl::ribuan($row2[2]);
     $txtdenda =genfuncpyl::ribuan($row2[3]);
     $txtjmlbayar =genfuncpyl::ribuan($row2[5]);
     $totaljmlbyr += $row2[5];

     $totalbunga+=$row2[2];
     $totaldenda+=$row2[3];
     
     $saldo=$row[4]-($i*$row2[1]);
     if($saldo<0){ $saldo = 0; }
     $txtsaldo = genfuncpyl::ribuan($saldo);
     $total += ($row2[1]+$row2[2]+$pokok+$sukarela);

     $total2 = $row2[1]+$row2[2]+$pokok+$sukarela;
     $txtpokok = genfuncpyl::ribuan($pokok);
     $txtsukarela = genfuncpyl::ribuan($sukarela);
     $txttotal2 = genfuncpyl::ribuan($total2);
     
     $isi .= qq~
    <tr bgcolor=$bg  class="hurufcol">
        <td align=center>$i</td>
        <td align=center>$row2[0]</td>
        <td align=right>$txtpokok</td>
        <td align=right>$txtsukarela</td>
        <td align=right>$txtangsuran</td>
        <td align=right>$txtbunga</td>
        <td align=right><b>$txttotal2</b></td>
        <td align=right>$txtsaldo</td>
    ~;
    if(!$in{print})
    { $isi .= qq~<td align=right>$txtdenda</td>
        <td align=right>$txtjmlbayar</td>
        <td align=right>$dtbayar</td>~;
    }
     $isi .= qq~ </tr>~;
     $i++;
  }
  $totalbaris = $i-1;
  
  $txtang = genfuncpyl::ribuan($row[4]);
  $txtdenda = genfuncpyl::ribuan($totaldenda);
  $txtbunga = genfuncpyl::ribuan($totalbunga);
  $txttotal = genfuncpyl::ribuan($total);
  $txttotaljmlbyr = genfuncpyl::ribuan($totaljmlbyr);
  $isi .= qq~ <tr bgcolor=$dark  class="hurufcol">
        <td align=left colspan=4><b>TOTAL </b></td>
        <td align=right><b>$txtang</b></td>
        <td align=right><b>$txtbunga</b></td>
        <td align=right><b>$txttotal</b></td>
        <td align=right>&nbsp;</td> ~;
    if(!$in{print})
    { $isi .= qq~<td align=right><b>$txtdenda</b></td>
        <td align=right><b>$txttotaljmlbyr</b></td>
        <td align=right>&nbsp;</td>~;
    }

    $isi .= qq~  </tr>
      </table> ~;

 if($totalbaris!=$masacicil)
 {
  $tambahan = qq~  <br/>
    <b>RINCIAN ANGSURAN SEBELUM PELUNASAN</b><br/>
    <table width=700 border=1 cellspacing=0 cellpadding=2>
      <tr bgcolor=$dark  class="hurufcol">
        <td align=center><b>No.</b></td>
        <td align=center><b>Bulan Angsuran</b></td>
        <td align=center><b>Angsuran</b></td>
        <td align=center><b>Bunga</b></td>
        <td align=center><b>Total </b></td>
      </tr>~;
  $q2 = $dbk->prepare("select periode, hrsbayar, bunga,denda from angsuran  where pinjaman_id = $row[7] and  batal='Y'
        order by periode");
  $q2->execute();
  $totalang=0; $totalbunga=0; $i=1; $total=0;
  while (@row2 = $q2->fetchrow_array())
  {  if($i%2==0) { $bg=$colcolor;  }
     else { $bg=$colcolor2;   }

     $txtangsuran =genfuncpyl::ribuan($row2[1]);
     $txtbunga =genfuncpyl::ribuan($row2[2]);

     $totalang+=$row2[1];
     $totalbunga+=$row2[2];
     $total += ($row2[1]+$row2[2]+$row2[3]);

     $total2 = $row2[1]+$row2[2]+$row2[3];
     $txttotal2 = genfuncpyl::ribuan($total2);
     $tambahan .= qq~
    <tr bgcolor=$bg  class="hurufcol">
        <td align=center>$i</td>
        <td align=center>$row2[0]</td>
        <td align=right>$txtangsuran</td>
        <td align=right>$txtbunga</td>
        <td align=right><b>$txttotal2</b></td>
      </tr>
        ~;
     $i++;
  }
  $txtang = genfuncpyl::ribuan($totalang);
  $txtbunga = genfuncpyl::ribuan($totalbunga);
  $txtdenda = genfuncpyl::ribuan($totaldenda);
  $txttotal = genfuncpyl::ribuan($total);
  $tambahan .= qq~ <tr bgcolor=$dark  class="hurufcol">
        <td align=left colspan=2><b>TOTAL </b></td>
        <td align=right><b>$txtang</b></td>
        <td align=right><b>$txtbunga</b></td>
        <td align=right><b>$txttotal</b></td>
      </tr>
      </table> ~;

 }

 if($in{print})
 {
  my $htmldoc = new HTML::HTMLDoc('mode'=>'file');
  $htmldoc->set_html_content(qq|
        <!DOCTYPE >
        <html>
        <head></head>
        <body>
        <h2 class=hurufcol>PERSETUJUAN PEMBAYARAN PINJAMAN</h2>
        <br/> <br/>
        Yang bertanda tangan di bawah ini :<br/>
        $header
        <br/> <br/>
        Bersedia memenuhi kewajiban saya sebagai peminjam, yaitu membayar sesuai dengan rincian pada tabel di bawah ini :
        <br/><br/>
        $isi
        <br/> <br/>
        <table width=80% border=0 cellpadding=2 cellspacing=0>
          <tr>
                <td>Tanggal : ___________________<br/>Peminjam,<br/><br/><br/><br/><br/><br/>$row[1] </td>
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
  $htmldoc->set_footer('D', '.', '.');
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
 }#end if ($in{print})

 print qq~<h2 class=hurufcol>DETAIL PINJAMAN</h2>
 $header <br/> $isi <br/> $tambahan <br/>
 <form method=post action="/cgi-bin/kopbox.cgi" >
      <input type="submit" name="print" value="Print" class="huruf1"/>
      <input name="display" type="hidden" value=kop021p>
      <input name="pid" type="hidden" value=$in{pid}>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
 ~;
 
 if($s3s[0] eq 'XTIN')
 { print qq~<form method=post action="/cgi-bin/kopbox.cgi" >
      <input type="submit" name="lunas" value="Set Lunas" class="huruf1"/>
      <input name="display" type="hidden" value=kop021p>
      <input name="pid" type="hidden" value=$in{pid}>
      <input name="ss" type="hidden" value="$in{ss}"> </form>~;
 }
 
}#end if $in{pid}

print qq ~
    <hr width="100" />
</center>
~;
}

;
1

