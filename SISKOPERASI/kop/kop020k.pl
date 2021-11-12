sub kop020k {

use HTML::HTMLDoc;
genfunckop::validasi_akses_kop($s3s[11], $in{ss});
$bgsukarela2 = "#c9f7ad";
$bgsukarela = "#bfe8a7";
$bgsukareladark = "#a9e884";

($month,$day,$year,$weekday) = &jdate(&today());
$month = substr "0$month",-2;
$periodenow = $year."-".$month;
if(!$in{tahun}){ $in{tahun}=$year; $in{tahun2}=$year;  }

print qq~
<script type='text/javascript' src='/jquery.min.js'></script>
<script type='text/javascript' src="/jquery.chained.js"></script>
<style type="text/css">
\@import url("/jscalendar/calendar-blue.css");
</style>

<script type="text/javascript" src="/jscalendar/calendar.js"></script>
<script type="text/javascript" src="/jscalendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="/jscalendar/calendar-setup.js"></script>

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
where a.idlama=k.idlama and a.aktif!='Z' order by nlengkap ");
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

$query = $dbk->prepare("select kodecabang, namastore, nik, nlengkap, dtjoin, a.idlama from anggota a, getkry k
where a.idlama=k.idlama and a.idlama=$in{idlama}
");
$query->execute();
@record = $query->fetchrow_array();
$dtberlaku = genfuncpyl::mdytodmy($record[4]);
$idlama = $record[5];
if(!$in{nikgo}){ $in{nikgo}=$record[2]; }

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
     <br/>
<form action="/cgi-bin/kopbox.cgi" method="post" name='vq'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=display value=kop020k>
  <input type=hidden name=idlama value=$in{idlama}>
<table>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp; Karyawan </td>
    <td class="hurufcol"> <input type=text name=nikgo id=nikgo value="$in{nikgo}" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase"></td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> &nbsp; Tahun </td>
    <td class="hurufcol" ><select name="tahun" class="huruf1" id="tahun">
    <option value=''>ALL</option>~;
($month,$day,$year,$weekday) = &jdate(&today());
for ($i=2016; $i<=$year; $i++)
{  $selected="";
   if ($in{tahun}==$i) { $selected="selected"; }
   print qq~<option value='$i' $selected> $i </option>~;
}
print qq~
    </select>  s/d <select name="tahun2" class="huruf1" id="tahun2">
    <option value=''>ALL</option>~;
($month,$day,$year,$weekday) = &jdate(&today());
for ($i=2017; $i<=$year; $i++)
{  $selected="";
   if ($in{tahun2}==$i) { $selected="selected"; }
   print qq~<option value='$i' $selected> $i </option>~;
}
print qq~
    </select>
    </td>
  </tr>
</table>
<input type='submit' name='view' value='Go'>  <input type='submit' name='print' value='Print'>  <br/> &nbsp;<br/>
</form> ~;

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
   <td align='center' class="hurufcol" colspan=4> <b>PINJAMAN</b> </td>
   <td align='center' class="hurufcol" rowspan=2 width=80 bgcolor="$bgsukareladark"> <b>TOTAL BAYAR</b> </td>
  </tr>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" width=75 bgcolor="$bgsukareladark"> <b>Pokok</b></td>
   <td align='center' class="hurufcol" width=75 bgcolor="$bgsukareladark"> <b>Sukarela</b> </td>
   <td align='center' class="hurufcol" width=75> <b>Saldo Pokok</b> </td>
   <td align='center' class="hurufcol" width=75> <b>Saldo Sukarela</b> </td>
   <td align='center' class="hurufcol" width=75 bgcolor="$bgsukareladark"> <b>Angsuran</b></td>
   <td align='center' class="hurufcol" width=75 bgcolor="$bgsukareladark"> <b>Bunga</b> </td>
   <td align='center' class="hurufcol" width=75 bgcolor="$bgsukareladark"> <b>Denda</b> </td>
   <td align='center' class="hurufcol" width=75> <b>Sisa Pinjaman</b> </td>
  </tr>~;

$query = $dbk->prepare("select jenis, sum(hrsbayar) from iuran where idlama= $idlama and periode<'$in{tahun}' group by jenis order by jenis");
$query->execute();
while(@rec = $query->fetchrow_array())
{ if($rec[0] eq 'P'){ $totalp=$rec[1]; }
  elsif($rec[0] eq 'S'){ $totals=$rec[1]; }
}

$query = $dbk->prepare("select sum(hrsbayar), sum(bunga) from pinjaman p, angsuran a
where p.recid=a.pinjaman_id and idlama=$idlama  and a.periode >= '$in{tahun}-01'");
$query->execute();
@rec = $query->fetchrow_array();
$sisapinj = $rec[0];

$txttotalp=genfuncpyl::ribuan($totalp);
$txttotals=genfuncpyl::ribuan($totals);
$txtsisapinj=genfuncpyl::ribuan($sisapinj);
$isi .= qq~
  <tr bgcolor="$colcolor2">
   <td align='center' class="hurufcol">Saldo</td>
   <td align='center' class="hurufcol"  bgcolor="$colcolor3">&nbsp;</td>
   <td align='center' class="hurufcol"  bgcolor="$colcolor3">&nbsp;</td>
   <td align='right' class="hurufcol">$txttotalp</td>
   <td align='right' class="hurufcol">$txttotals</td>
   <td align='center' class="hurufcol"  bgcolor="$colcolor3">&nbsp;</td>
   <td align='center' class="hurufcol"  bgcolor="$colcolor3">&nbsp;</td>
   <td align='center' class="hurufcol"  bgcolor="$colcolor3">&nbsp;</td>
   <td align='right' class="hurufcol">$txtsisapinj</td>
   <td align='center' class="hurufcol" >&nbsp;</td>
  </tr>
~;

$query = $dbk->prepare("select p.recid, i.periode, jenis, i.hrsbayar, x.jmlbayar-x.bunga-x.denda, x.bunga, i.pencairanid, x.denda, x.jmlpengajuan from periode p
left outer join iuran i on p.recid=i.periode and idlama=$idlama and i.periode >='$in{tahun}-01' and i.periode<='$in{tahun2}-12'
left outer join (select a.periode, jmlbayar, bunga,denda, jmlpengajuan from pinjaman p, angsuran a
where p.recid=a.pinjaman_id and idlama=$idlama  and a.periode >='$in{tahun}-01' and a.periode<='$in{tahun2}-12'
and a.periode <='$periodenow' and batal='N' and jmlbayar!=0 ) x
on p.recid=x.periode
where p.recid >='$in{tahun}-01'  and p.recid<='$in{tahun2}-12' ");
$query->execute(); $no=1; $totalrow=0; $flag=0;
while(@rec = $query->fetchrow_array())
{ if($no%2==1){ $bg=$colcolor; }
  else { $bg=$colcolor2; }
  if($tmp ne $rec[0])
  {
    if($flag==1)
    {  if($tmpangsuran)
       { $sisapinj-=$tmpangsuran;
         $totalrow=($tmpangsuran+$tmpbunga+$tmpdenda);
         $angsuran = genfuncpyl::ribuan($tmpangsuran);
         $bunga = genfuncpyl::ribuan($tmpbunga);
         $txtdenda=genfuncpyl::ribuan($tmpdenda);
         $txtsisapinj=genfuncpyl::ribuan($sisapinj);
         $txttotalrow=genfuncpyl::ribuan($totalrow);
         $isi .= qq~
     <td align='right' class="hurufcol"  bgcolor="$tmpbg" >&nbsp; </td>
     <td align='right' class="hurufcol">&nbsp; </td>
     <td align='right' class="hurufcol">&nbsp;</td>
     <td align='right' class="hurufcol"  bgcolor="$tmpbg2">$angsuran </td>
     <td align='right' class="hurufcol"  bgcolor="$tmpbg2">$bunga </td>
     <td align='right' class="hurufcol"  bgcolor="$tmpbg2">$txtdenda </td>
     <td align='right' class="hurufcol">$txtsisapinj </td>
     <td align='right' class="hurufcol">$txttotalrow </td>
    </tr>~;
       }
       else
       {
         $isi .= qq~
     <td align='right' class="hurufcol"  bgcolor="$tmpbg" >&nbsp; </td>
     <td align='right' class="hurufcol">&nbsp; </td>
     <td align='right' class="hurufcol">&nbsp; </td>
     <td align='right' class="hurufcol"  bgcolor="$tmpbg2">&nbsp; </td>
     <td align='right' class="hurufcol"  bgcolor="$tmpbg2">&nbsp; </td>
     <td align='right' class="hurufcol"  bgcolor="$tmpbg2">&nbsp; </td>
     <td align='right' class="hurufcol">&nbsp; </td>
     <td align='right' class="hurufcol">&nbsp; </td>
    </tr>~;
       }
    }
    $pokok = genfuncpyl::ribuan($rec[3]);
    $totalp+=$rec[3];
    $totalrow=$rec[3];
    if($no%2==0) {  $bg2=$bgsukarela2; }
    else {   $bg2=$bgsukarela; }

    $bgs = $bg2;
    if($rec[6]) { $bgs = "coral";}


    $isi .= qq~<tr bgcolor=$bg>
     <td align='center' class="hurufcol">$rec[0]</td>
     <td align='right' class="hurufcol"  bgcolor="$bgs">$pokok</td>
    ~;
    $no++;
    $flag=1;
    $tmpangsuran = $rec[4];
    $tmpbunga = $rec[5];
    $tmpdenda = $rec[7];
    $tmpjmlpengajuan = $rec[8];
  }
  else
  { $totals+=$rec[3];
    $totalrow+=$rec[3];

    if($rec[4])
    { $sisapinj-=$rec[4];
      $totalrow+=($rec[4]+$rec[5]+$rec[7]);
      $angsuran = genfuncpyl::ribuan($rec[4]);
      $bunga = genfuncpyl::ribuan($rec[5]);
      $txtsisapinj=genfuncpyl::ribuan($sisapinj);
    }
    else
    { $angsuran=0; $bunga=0; $txttotalpinj=0; }

    $bgs = $bg2;
    if($rec[6]) { $bgs = "coral";}

    $sukarela = genfuncpyl::ribuan($rec[3]);
    $txttotalp=genfuncpyl::ribuan($totalp);
    $txttotals=genfuncpyl::ribuan($totals);
    $txttotalrow=genfuncpyl::ribuan($totalrow);
    $txtdenda=genfuncpyl::ribuan($rec[7]);
    $isi .= qq~
     <td align='right' class="hurufcol"  bgcolor="$bgs" >$sukarela</td>
     <td align='right' class="hurufcol">$txttotalp</td>
     <td align='right' class="hurufcol">$txttotals</td>
     <td align='right' class="hurufcol"  bgcolor="$bg2">$angsuran</td>
     <td align='right' class="hurufcol"  bgcolor="$bg2">$bunga</td>
     <td align='right' class="hurufcol"  bgcolor="$bg2">$txtdenda</td>
     <td align='right' class="hurufcol">$txtsisapinj</td>
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

