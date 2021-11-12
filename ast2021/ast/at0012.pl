sub at0012 {

&koneksi_ast2;

genfuncast::view_header($in{ss}, $s3s[2], 'MIS Menerima');
genfuncast::validasi_akses($s3s[11], $in{ss});
use HTML::HTMLDoc;

@yesno = ("ALL", "Y","N");
@kembali = ("ALL", "Y","N");
@kembali_value = ("", "K","N");
if(!$in{batal}){ $in{batal}='N'; }

($month,$day,$year,$weekday) = &jdate(&today());
$month=substr "0$month",-2;
$pridtoday=$year."-".$month;

print qq~
<script type='text/javascript' src='/jquery.min.js'></script>
<script type='text/javascript' src="/jquery.chained.js"></script>

<style type="text/css">\@import url("/jscalendar/calendar-blue.css");</style>
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

  \$(function(\$) {
    var data1 = [
~;
$str="";
$query = $dba1->prepare("select kodecabang,namacabang, kodebu from getstruk order by kodecabang");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $str.= qq~  { label: "$rec[0]-$rec[1]", category: "$rec[2]" },~ ;
}
$n = length($str) - 1;
$str = substr $str,0,$n;

print qq~
      $str
    ];


    \$("#cabang").catcomplete({
      delay: 0,
      source: data1
    });
  });
  </script>
~;

print qq~
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
  \$(function(\$) {
    var data2 = [
~;
$str="";
$query = $dba1->prepare("select nik,nlengkap,kodecabang from getkry order by kodecabang");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $str.= qq~ { label: "$rec[0]-$rec[1]", category: "$rec[2]" },~ ;
}
$n = length($str) - 1;
$str = substr $str,0,$n;

print qq~
      $str
    ];

    \$("#kry").catcomplete({
      delay: 0,
      source: data2
    });
  });
  </script>
~;

print qq~
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=right width=150>&nbsp; </td>
     <td align=center> <h2 class="hurufcol"> MIS Menerima</h2> </td>
     ~;
if ($s3s[11] eq 'S')
{     print qq~<td align=right width=50>
      <form method=post action="/cgi-bin/sisasset.cgi" >
      <input type="submit" name="back" value="Terima" class="huruf1"/>
      <input name="pages" type="hidden" value=at0013>
      <input name="ss" type="hidden" value="$in{ss}"> </form> </td>
      <td align=right width=100>
      <form method=post action="/cgi-bin/sisasset.cgi" >
      <input type="submit" name="back" value="Kembalikan Pinjaman" class="huruf1"/>
      <input name="pages" type="hidden" value=at0013k>
      <input name="ss" type="hidden" value="$in{ss}"> </form> </td>~;
}     print qq~
     </tr>
     </table>

<form action="/cgi-bin/sisasset.cgi" method="post" name='vq'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at0012>
<table>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp;Tgl Terima </td>
    <td class="hurufcol" > <input name="dtst" type="text" id="dtst" size="12" maxlength="12" class="huruf1" value="$in{dtst}" />
        <img src="/jscalendar/img.gif" id="trigger1" style="cursor: pointer; border: 1px solid blue;"
                title="Date selector" onMouseOver="this.style.background='blue';" onMouseOut="this.style.background=''" />
        <script type="text/javascript">
        Calendar.setup(
        {
                inputField  : "dtst",         // ID of the input field
                ifFormat    : "%m/%d/%Y",    // the date format
                button      : "trigger1"       // ID of the button
	       //daFormat  :  "%Y/%m/%d"
        }
        );
        </script>  s/d   <input name="dtst2" type="text" id="dtst2" size="12" maxlength="12" class="huruf1" value="$in{dtst2}" />
        <img src="/jscalendar/img.gif" id="trigger2" style="cursor: pointer; border: 1px solid blue;"
                title="Date selector" onMouseOver="this.style.background='blue';" onMouseOut="this.style.background=''" />
        <script type="text/javascript">
        Calendar.setup(
        {
                inputField  : "dtst2",         // ID of the input field
                ifFormat    : "%m/%d/%Y",    // the date format
                button      : "trigger2"       // ID of the button
	       //daFormat  :  "%Y/%m/%d"
        }
        );
        </script>
    </td>
    <td class="hurufcol"> &nbsp;Pengembalian Pinjaman </td>
    <td class="hurufcol" > ~;
for ($i=0; $i<@yesno; $i++)
{  $checked="";
   if($in{kembali} eq $kembali_value[$i]){ $checked="checked"; }
   print qq~<input type=radio name=kembali value='$kembali_value[$i]' $checked/> $kembali[$i] &nbsp; ~;
}
print qq~</td>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp;Cabang Asal</td>
    <td class="hurufcol" >
    <input type=text name=cabang id=cabang value="$in{cabang}" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase">
     </td>
    <td class="hurufcol"> &nbsp;Batal </td>
    <td class="hurufcol" > ~;
for ($i=0; $i<@yesno; $i++)
{  $checked="";
   if($in{batal} eq $yesno[$i]){ $checked="checked"; }
   print qq~<input type=radio name=batal value='$yesno[$i]' $checked/> $yesno[$i] &nbsp; ~;
}
print qq~</td>
    </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp;Karyawan Asal</td>
    <td class="hurufcol" >
    <input type=text name=kry id=kry value="$in{kry}" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase">
    </td>
    <td class="hurufcol">&nbsp;Jenis Inventori</td>
    <td class="hurufcol"><select name="jenisinv" class="huruf1" id="jenisinv">
    <option value=''>-</option>~;
$query = $dba1->prepare("SELECT jenis, namajenis FROM JENISINV ORDER BY jenis, namajenis  ");
$query->execute();
while (@record = $query->fetchrow_array())
{  $selected="";
   if ($in{jenisinv} eq $record[0]) { $selected="selected"; }
   print qq~<option value='$record[0]' $selected> $record[0] - $record[1] </option>~;
}
print qq~
      </select></td>
    </tr>
    <tr>
      <td align=center colspan=4><input type='submit' name='search' value='Search'> </td>
    </tr>
</table>
</form>
~;

if($in{terimabatal})
{ $query = $dba1->prepare("
  select kodeinv, cabang_asal, idlama_asal, kondisi_asal, ket_asal, h.flagpinjam, h.dtkirim from kirimd d, kirimh h
    where d.kirimid=h.recid and kirimid=$in{terimabatal} and d.batal='N' ");
  $query->execute(); $sukses=0;
  $upstokfield = "terima";  $subup="";
  while(@rec = $query->fetchrow_array())
  {   if($rec[5] eq 'K'){ $upstokfield = "pnjterima"; $subup=" flagpinjam='Y', "; }
      print qq~update inventori set currcabang='$rec[1]', curridlama='$rec[2]', kondisi='$rec[3]', keterangan='$rec[4]', $subup
       oprupdate='$s3s[0]' where kode='$rec[0]';~;
      
      $q1 = $dba2->do("update inventori set currcabang='$rec[1]', curridlama='$rec[2]', kondisi='$rec[3]', keterangan='$rec[4]', $subup
       oprupdate='$s3s[0]' where kode='$rec[0]';");

      $jenisinv=substr $rec[0],0,6;
      $rec[6] = genfuncast::formatMDY($rec[6]);
      ($m,$d,$y)=genfuncast::getMdy($rec[6]);
      $m=substr "0$m",-2;
      $periode = $y."-".$m;
      if($q1!=0)
      { $q2 = $dba2->do("update stok set $upstokfield=$upstokfield-1, oprupdate='$s3s[0]' where jenisinv='$jenisinv' ;");
        if($q2!=0){ $sukses++; }
      }
  }
  if($sukses>0)
  {
#  print qq~update kirimd set batal='Y', oprupdate='$s3s[0]' where kirimid='$in{terimabatal}' and batal='N';<br/>
#      update kirimh set batal='Y', oprupdate='$s3s[0]' where recid='$in{terimabatal}';~;
     $q2 = $dba2->do("update kirimd set batal='Y', oprupdate='$s3s[0]' where kirimid='$in{terimabatal}' and batal='N';");
     $q3 = $dba2->do("update kirimh set batal='Y', oprupdate='$s3s[0]' where recid='$in{terimabatal}';");
     $q4 = $dba2->do("update kirimd set kembaliid=null, oprupdate='$s3s[0]' where kembaliid='$in{terimabatal}';");
     if($q2!=0 and $q3!=0 and $q4!=0) { print qq~<div class=warning_ok>Sukses Batalkan Terima </div> ~; }
     else { print qq~<div class=warning_not_ok>Gagal Batalkan Terima </div> ~; }
  }
}

if($in{search})
{
if ($s3s[11] eq 'S')
{
print qq ~
<script type="text/javascript">
function toedit(n)
{  with(document.st)
   { pages.value='at0012se';
     recidh.value=n;
     submit();
   }
}
function toprint(n)
{  with(document.st)
   { pages.value='at0012';
     recidprint.value=n;
     submit();
   }
}
function tobatalterima(n)
{  var result = confirm("Yakin Batalkan Terima ?");
   if (result==true)
   {
      with(document.st)
      { pages.value='at0012';
        terimabatal.value=n;
        submit();
      }
   }
}
</script>
 $warning_del
<FORM ACTION="/cgi-bin/sisasset.cgi" METHOD="post" name='st'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at0012>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <input type=hidden name=recidh value=>
  <input type=hidden name=recidprint value=>
  <input type=hidden name=recidsbatal value=>
  <input type=hidden name=terimabatal value=>
 ~;
}
print qq~
<link rel="stylesheet" href="/colorbox.css" />
<script type="text/javascript" src="/jquery.colorbox.js"></script>

<script type="text/javascript">
\$(document).ready(function(){
   \$(".iframe").colorbox({
      iframe:true,
      width:"1150px",
      height:"95%"});

    \$("#click").click(function(){
	 \$(".iframe").colorbox.close();
    });
});
</script>
<table width='1000px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" width=50> No. </td>
   <td align='center' class="hurufcol" width=100> No. Surat  </td>
   <td align='center' class="hurufcol" width=100> Tgl Terima </td>
   <td align='center' class="hurufcol" width=100> Cabang Asal  </td>
   <td align='center' class="hurufcol" width=100> Karyawan Asal</td>
   <td align='center' class="hurufcol" width=80> Jumlah Inventori </td>
   <td align='center' class="hurufcol" width=80> Pengembalian</td>
   <td align='center' class="hurufcol" width=100> Action </td>
  </tr>
~;

$subq=""; $subqkirimd="";
if ($in{dtst}) {$subq.=" and dtkirim>='$in{dtst}'"; }
if ($in{dtst2}) {$subq.=" and dtkirim<='$in{dtst2}'"; }
if ($in{cabang}) { @cab = split(/\-/,$in{cabang}); $subq.=" and kodecabang='$cab[0]'"; }
if ($in{kry})
{  @kry = split(/\-/,$in{kry});
   $query = $dba1->prepare("select idlama from getkry where nik='$kry[0]'");
   $query->execute();
   @row = $query->fetchrow_array();
   $idlama=$row[0];
   $subq.=" and idlama_asal='$idlama'";
}
if($in{batal} and $in{batal} ne 'ALL'){ $subq.=" and batal='$in{batal}'"; }
if ($in{kembali}) {$subq.=" and flagpinjam='$in{kembali}'"; }
if ($in{jenisinv}) {$subqkirimd.=" where kodeinv like '$in{jenisinv}%'  "; }

#if($s3s[0] eq 'XTIN')
#{ print qq~select nosurat, jenis, dtkirim, namacabang, idlama_asal, jml, h.recid, h.batal, printke, flagpinjam
#from kirimh h  join
#(select kirimid, cabang_asal, idlama_asal, count(*) jml from kirimd $subqkirimd group by kirimid, cabang_asal, idlama_asal)
#d on h.recid=d.kirimid
#left outer join getstruk c on d.cabang_asal=c.kodecabang  where jenis='T'  $subq order by  nosurat,dtkirim <br/> ~;
#}

$q = $dba1->prepare("select nosurat, jenis, dtkirim, namacabang, idlama_asal, jml, h.recid, h.batal, printke, flagpinjam
from kirimh h  join
(select kirimid, cabang_asal, idlama_asal, count(*) jml from kirimd $subqkirimd group by kirimid, cabang_asal, idlama_asal)
d on h.recid=d.kirimid
left outer join getstruk c on d.cabang_asal=c.kodecabang  where jenis='T'  $subq order by  nosurat,dtkirim
");

$q->execute();
$no=1;
while (@row = $q->fetchrow_array())
{ $btn="";
  $kembalipinj="";
  if($row[9] eq 'K'){ $kembalipinj='Y'; }
  if ($s3s[11] eq 'S' )
  { $btn = "
    <a class=iframe  href='asetbox.cgi?display=at0012p&recidprint=$row[6]&ss=$in{ss}'><img src='/images/print.png'></a>&nbsp;";

    $row[2] = genfuncast::formatMDY($row[2]);
    ($m,$d,$y)=genfuncast::getMdy($row[2]);
    $m=substr "0$m",-2;
    $periode = $y."-".$m;

    if($row[7] eq 'N' and $row[8]==0 and $periode eq $pridtoday)
    {
      $btn .= "
      <input type='image' src='/images/del.png' name='batal$no' value='Batal' class='huruf1' onClick=\"tobatalterima('$row[6]');\">";
    }
  }

  $dt = genfuncast::mdytodmy($row[2]);
  $nama = "";
  if($row[4]!=0)
  {
   $query = $dba2->prepare("select nlengkap from getkry where idlama='$row[4]'");
   $query->execute();
   @rec = $query->fetchrow_array();
   $nama = $rec[0];
  }
  
  if($row[7] eq 'Y'){ $bg="#ccc"; }
  else
  { if($no%2==1){ $bg=$colcolor; }
    else { $bg=$colcolor2; }
  }
  print qq~
  <tr bgcolor=$bg height=20>
     <td align='center' class="hurufcol" valign='top'>$no </td>
     <td align='center' class="hurufcol" valign='top'>
     <a class=iframe href="asetbox.cgi?display=at0013b&rid=$row[6]&ss=$in{ss}">$row[0]</a></td>
     <td align='center' class="hurufcol" valign='top'>$dt</td>
     <td class="hurufcol" valign='top'>$row[3]</td>
     <td class="hurufcol" valign='top'>$nama</td>
     <td align='center' class="hurufcol" valign='top'>$row[5]</td>
     <td align='center' class="hurufcol" valign='top'>$kembalipinj </td>
     <td align='center' valign='top'>$btn </td>
  </tr>
  ~;
  $no++;
}

print qq ~</table>
Note : Batalkan Terima Hanya Untuk Yang Tgl Terima = Bulan Ini
~;

if ($s3s[11] eq 'S')
{  print qq ~</form>~;
}
}
print qq ~
    <hr width="100" />
</center>
~;
}

;
1

