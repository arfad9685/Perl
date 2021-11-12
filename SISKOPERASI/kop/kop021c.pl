sub kop021c {

use HTML::HTMLDoc;
use Date::Calc qw(Add_Delta_Days);
genfunckop::validasi_akses_kop($s3s[11], $in{ss});

$xtin=0;
print qq~
<script type='text/javascript' src='/jquery.min.js'></script>
<script type='text/javascript' src="/jquery.chained.js"></script>
<style type="text/css">
\@import url("/jscalendar/calendar-blue.css");
</style>

<script type="text/javascript" src="/jscalendar/calendar.js"></script>
<script type="text/javascript" src="/jscalendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="/jscalendar/calendar-setup.js"></script>
      <br/> &nbsp;   <br/>
     <table width=100% border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=150>
     &nbsp;
     </td>
     <td align=center> <h2 class="hurufcol"> TAMBAH PEMINJAM</h2> </td>
     <td align=left width=150>&nbsp; </td>
     </tr>
     </table>
     <br/>
~;

if($in{simpan})
{
   $in{jumlah}=~ s/\'/\ /g;
   $in{jumlah}=~ s/\"/\ /g;
   $in{nikgo} = substr $in{nikgo},0,9;
   $in{nikgo} = uc $in{nikgo} ;
   
   ($month,$day,$year,$weekday) = &jdate(&today());
   $month=substr "0$month",-2;
   $day=substr "0$day",-2;
   $ymdtoday = $year."-".$month."-".$day;
   $in{dttrf}=genfuncpyl::formatMDY($in{dttrf});
   $ymddttrf=genfuncpyl::mdytoymd($in{dttrf});

   $wrn='';
   if (!($in{nikgo})) { $wrn.="<li>Karyawan Peminjam</li>"; }
   if (!($in{jumlah})) { $wrn.="<li>Jumlah Pinjaman</li>"; }
   if (!($in{cicil})) { $wrn.="<li>Masa Cicil</li>"; }
   if (!($in{dtapp})) { $wrn.="<li>Tgl Approve</li>"; }
   if (!($in{dttrf})) { $wrn.="<li>Tgl Transfer</li>"; }
#   if($ymddttrf lt $ymdtoday){ $wrn.="<li>Tgl Transfer tidak boleh < Tgl Hari Ini</li>"; }

   if ($wrn ne "" )
   {  $warning = "<div class='warning_not_ok'>Isilah field-field di bawah dengan format yang benar: $wrn</div><br/>";
   }
   else
   {
      $query = $dbp->prepare("select idlama, statuskerja from stafbiodata where nik='$in{nikgo}' ");
      $query->execute();
      @rec = $query->fetchrow_array();
      $idlama = $rec[0];
      $statuskerja = $rec[1];
      $pridapp = genfunckop::getPeriodeKop($in{dtapp});

      $query = $dbk->prepare("select max(recid) from pinjaman  ");
      $query->execute();
      @rec = $query->fetchrow_array();
      $recid = $rec[0]+1;
      if($s3s[0] eq 'XTIN' and $xtin==1)
      { print "INSERT INTO PINJAMAN (RECID, PERIODE, IDLAMA, STATUSKERJA, JMLPENGAJUAN, MASACICIL, DTAPPROVE, JMLAPPROVE, DTTRANSFER, OPRCREATE) VALUES
         ($recid, '$pridapp', '$idlama','$statuskerja', '$in{jumlah}', '$in{cicil}', '$in{dtapp}', '$in{jumlah}', '$in{dttrf}', '$s3s[0]');<br/>";
      }
      $q1 = $dbk->do("INSERT INTO PINJAMAN (RECID, PERIODE, IDLAMA, STATUSKERJA, JMLPENGAJUAN, MASACICIL, DTAPPROVE, JMLAPPROVE, DTTRANSFER, OPRCREATE) VALUES
         ($recid, '$pridapp', '$idlama','$statuskerja', '$in{jumlah}', '$in{cicil}', '$in{dtapp}', '$in{jumlah}', '$in{dttrf}', '$s3s[0]');");

      if($q1!=0)
      {
        $angsuran = $in{jumlah}/$in{cicil};
        $sisapinjaman = $in{jumlah};
        $in{dttrf}=genfuncpyl::formatMDY($in{dttrf});
        ($m,$d,$y)=genfuncpyl::getMdy($in{dttrf});
        $ctr=0;
        for ($i=1;$i<=$in{cicil}; $i++)
        { if($s3s[0] eq 'XTIN' and $xtin==1)
          {  print "INSERT INTO ANGSURAN (PINJAMAN_ID, PERIODE, HRSBAYAR, BUNGA, OPRCREATE) VALUES
            ($recid, '".$in{"prid$i"}."', '".$in{"ang$i"}."', '".$in{"bunga$i"}."', '$s3s[0]');<br/>";
          }
          
          $ctr += $dbk->do("INSERT INTO ANGSURAN (PINJAMAN_ID, PERIODE, HRSBAYAR, BUNGA, OPRCREATE) VALUES
          ($recid, '".$in{"prid$i"}."', '".$in{"ang$i"}."', '".$in{"bunga$i"}."', '$s3s[0]');");
        }
        
        if($ctr==$in{cicil}){ $warning= qq~<div class=warning_ok> Sukses Tambah Pinjaman </div> ~;}
        else
        { $warning= qq~<div class=warning_not_ok> Tidak Berhasil Tambah Pinjaman : $ctr </div> ~;
          $q1 = $dbk->do("delete from angsuran where pinjaman_id=$recid ");
          $q1 = $dbk->do("delete from pinjaman where recid=$recid");

        }
      }
   }
   print qq~$warning~;
}
else
{
print qq~
<script type='text/javascript' src='/jquery-ui.js'></script>
<link rel="stylesheet" href="/jquery-ui.css">
<style>
  .ui-autocomplete-category {
    font-weight: bold;
    padding: .2em .4em;
    margin: .8em 0 .2em;
    line-height: 1.5;
  }
  </style>
  <script>
  \$.widget( "custom.catcomplete", \$.ui.autocomplete, {
    _create: function() {
      this._super();
      this.widget().menu( "option", "items", "> :not(.ui-autocomplete-category)" );
    },
    _renderMenu: function( ul, items ) {
      var that = this,
        currentCategory = "";
      \$.each( items, function( index, item ) {
        var li;
        if ( item.category != currentCategory ) {
          ul.append( "<li class='ui-autocomplete-category'>" + item.category + "</li>" );
          currentCategory = item.category;
        }
        li = that._renderItemData( ul, item );
        if ( item.category ) {
          li.attr( "aria-label", item.category + " : " + item.label );
        }
      });
    }
  });
  </script>
  <script>
  \$(function() {
    var data = [
~;
$query = $dbk->prepare("
select nik, nlengkap, kodecabang  from anggota a, getkry k
where a.idlama=k.idlama  and a.idlama not in (select idlama from pinjaman where lunas='N' and batal='N') and a.aktif='Y' order by nlengkap ");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $str.= qq~ { label: "$rec[0] - $rec[1]", category: "$rec[2]" },~ ;
}
$n = length($str) - 1;
$str = substr $str,0,$n;

print qq~
      $str
    ];

    \$( "#nikgo" ).catcomplete({
      delay: 0,
      source: data
    });
  });
  </script>
  
~;
print qq~  <form action="/cgi-bin/kopbox.cgi" method="post" name='vq'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=display value=kop021c>
<table>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp; Karyawan </td>
    <td class="hurufcol"> <input type=text name=nikgo id=nikgo value="$in{nikgo}" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase"></td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp; Jumlah Pinjaman </td>
    <td class="hurufcol"> <input type=text name=jumlah id=jumlah value="$in{jumlah}" size=10 style="text-align: right"></td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp; Masa Cicil  </td>
    <td class="hurufcol"><select name=cicil id=cicil> ~;
for ($i=1; $i<=20; $i++)
{ $selected = "";
  if($in{cicil}==$i){  $selected = "selected"; }
  print qq~<option value=$i $selected>$i</option>~;
}
print qq~</select></td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp; Tgl Approve </td>
    <td class="hurufcol" ><input class='huruf1' name="dtapp" type="text" id="dtapp" size="12" maxlength="12" value="$in{dtapp}" />
       <img src="/jscalendar/img.gif" id="trigger3" style="cursor: pointer; border: 1px solid blue;" title="Date selector" onMouseOver="this.style.background='blue';" onMouseOut="this.style.background=''" />
       <script type="text/javascript">
       Calendar.setup(
       {
        inputField  : "dtapp",         // ID of the input field
        ifFormat    : "%m/%d/%Y",    // the date format
        button      : "trigger3"       // ID of the button
	  //daFormat  :  "%Y/%m/%d"
        }
       );
       </script>
    </td>
    </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp; Tgl Transfer </td>
    <td class="hurufcol" ><input class='huruf1' name="dttrf" type="text" id="dttrf" size="12" maxlength="12" value="$in{dttrf}" />
       <img src="/jscalendar/img.gif" id="trigger4" style="cursor: pointer; border: 1px solid blue;" title="Date selector" onMouseOver="this.style.background='blue';" onMouseOut="this.style.background=''" />
       <script type="text/javascript">
       Calendar.setup(
       {
        inputField  : "dttrf",         // ID of the input field
        ifFormat    : "%m/%d/%Y",    // the date format
        button      : "trigger4"       // ID of the button
	  //daFormat  :  "%Y/%m/%d"
        }
       );
       </script>
    </td>
    </tr>
   <tr>
    <td colspan=2 align=center><input type='submit' name='detil' value='Lihat Detail Cicilan'><br/>
     ~;
if($in{detil} or $in{print})
{ $tmpnikgo = $in{nikgo};
  $in{nikgo} = substr $in{nikgo},0,9;
  $in{nikgo} = uc $in{nikgo} ;
  $in{dttrf}=genfuncpyl::formatMDY($in{dttrf});
 ($m,$d,$y)=genfuncpyl::getMdy($in{dttrf});

 $query = $dbk->prepare("select jumlah from simpanan s, getkry k
where s.idlama=k.idlama and  nik='$in{nikgo}'  and dtexpired='1/1/2099' order by jenis");
 $query->execute();
 $i=0;
 while(@rec = $query->fetchrow_array())
 {  if($i==0){ $pokok = $rec[0]; }
    else { $sukarela=$rec[0]; }
    $i++;
 }
 
 $query = $dbk->prepare("select p.recid, a.dtjoin, datediff(month, dtjoin, date '$m/1/$y') from getkry k
  left outer join anggota a on  k.idlama=a.idlama
  left outer join pinjaman p on  p.idlama=k.idlama and lunas='N'
  where  k.nik='$in{nikgo}'");
 $query->execute();
 @rec = $query->fetchrow_array();
 if($rec[0]){ print "<div class=warning_not_ok>NIK '$in{nikgo}' masih ada pinjaman yang belum lunas</div>"; }
 elsif($rec[2]<5){ print "<div class=warning_not_ok>Keanggotaan NIK '$in{nikgo}' belum 6 bulan </div>"; }
 else
 {
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
      </tr>~;

  $angsuran = $in{jumlah}/$in{cicil};
  $txtangsuran =genfuncpyl::ribuan($angsuran);
  $sisapinjaman = $in{jumlah};
  $totalbunga = 0;  $total=0;

  for ($i=1;$i<=$in{cicil}; $i++)
  { $bunga[$i]=$sisapinjaman*0.01;
    $sisapinjaman = $in{jumlah}-($i*$angsuran);
    
    ($yr, $mn, $dy) = Add_Delta_Days($y,$m,$d,30*$i);
    if ($mn<10) {$mn="0".$mn;}
    if ($dy<10) {$dy="0".$dy;}
    $dt = $mn.'/'.$dy.'/'.$yr;
    $prid = genfunckop::getPeriodeKop($dt);
    
    if($i%2==1){ $bg=$colcolor; }
    else { $bg=$colcolor2; }
    $txtbunga = genfuncpyl::ribuan($bunga[$i]);
    $txtsubtotal = genfuncpyl::ribuan($angsuran+$bunga[$i]);
    $totalbunga+=$bunga[$i];
    $txtsaldo = genfuncpyl::ribuan($in{jumlah}-($i*$angsuran));
    $total += ($angsuran + $bunga[$i]);

    $total2 = $angsuran+$bunga[$i]+$pokok+$sukarela;
    $txtpokok = genfuncpyl::ribuan($pokok);
    $txtsukarela = genfuncpyl::ribuan($sukarela);
    $txttotal2 = genfuncpyl::ribuan($total2);

     $isi .= qq~
    <tr bgcolor=$bg  class="hurufcol">
        <td align=center>$i</td>
        <td align=center>$prid</td>
        <td align=right>$txtpokok</td>
        <td align=right>$txtsukarela</td>
        <td align=right>$txtangsuran</td>
        <td align=right>$txtbunga</td>
        <td align=right><b>$txttotal2</b></td>
        <td align=right>$txtsaldo</td>
      </tr>
     <input type=hidden name=prid$i value=$prid>
     <input type=hidden name=ang$i value=$angsuran>
     <input type=hidden name=bunga$i value=$bunga[$i]>
        ~;
  }
  $txtang = genfuncpyl::ribuan($in{jumlah});
  $txtbunga = genfuncpyl::ribuan($totalbunga);
  $txttotal = genfuncpyl::ribuan($total);
  $isi .= qq~ <tr bgcolor=$dark  class="hurufcol">
        <td align=left colspan=4><b>TOTAL </b></td>
        <td align=right><b>$txtang</b></td>
        <td align=right><b>$txtbunga</b></td>
        <td align=right><b>$txttotal</b></td>
        <td align=right>&nbsp;</td>
      </tr>
      </table> ~;
  if($in{detil})
  {
    print qq~ $isi
     </td>
    </tr>
    <tr >
     <td colspan=2 align=center><input type='submit' name='simpan' value='Simpan'> <input type='submit' name='print' value='Print Simulasi'></td>
    </tr>
    </table> ~;
  }
  elsif($in{print})
  {
        my $htmldoc = new HTML::HTMLDoc('mode'=>'file');
        $htmldoc->set_html_content(qq|
        <!DOCTYPE >
        <html>
        <head></head>
        <body>
        <h2 class=hurufcol>SIMULASI PEMBAYARAN PINJAMAN</h2>
        <br/> <br/>
        <table width=90% border=0 cellpadding=2 cellspacing=0>
          <tr class=hurufcol> <td width=150>NIK - Nama Karyawan  </td><td>: $tmpnikgo</td>  </tr>
          <tr class=hurufcol> <td>Tanggal Pinjaman </td><td>: $in{dttrf}</td>  </tr>
          <tr class=hurufcol> <td>Jumlah Pinjaman  </td><td>: $txtang</td>  </tr>
          <tr class=hurufcol> <td>Bunga Pinjaman   </td><td>: 1 %</td>  </tr>
          <tr class=hurufcol> <td>Lama Angsuran   </td><td>: $in{cicil} bulan</td>  </tr>
        </table>
        <br/> <br/>
        $isi
        </body>
        </html>
        |);

        $htmldoc->portrait();
        $htmldoc->set_page_size("A4");
        $htmldoc->set_bodyfont('Arial'); # set font
        $htmldoc->set_fontsize('8'); # set font
        $htmldoc->set_left_margin(1, 'cm'); # set margin
        $htmldoc->set_right_margin(1, 'cm'); # set margin
        $htmldoc->set_bottom_margin(1, 'cm'); # set margin
        $htmldoc->set_top_margin(1, 'cm'); # set margin
        $htmldoc->title('SIMULASI PEMBAYARAN PINJAMAN');
        $htmldoc->set_footer('D', '.', '.');
        my $pdf = $htmldoc->generate_pdf();

        $direktori='/home/sarirasa/htdocs/download/7104/';
        $nik = substr $in{nikgo},0,9;
        $dt = genfuncpyl::mdytodmy$in{dttrf};
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

  
  print qq~  </form>    ~;
 }#end else

}#end if $in{detil} or $in{print}


}

print qq ~
    <hr width="100" />
</center>
~;
}

sub hitungcicil {
    ($jumlah, $cicil) = @_;
    $angsuran = $jumlah/$cicil;
    $sisapinjaman = $jumlah;
    
    for ($i=1; $i<=$cicil; $i++)
    { $bunga[$i]=$sisapinjaman*0.01;
      $sisapinjaman = $jumlah-($i*$angsuran);
    }
    return @bunga;
}
;
1

