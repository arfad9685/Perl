sub at0017 {

&koneksi_ast2;

genfuncast::view_header($in{ss}, $s3s[2], 'MIS Menyerahkan');
genfuncast::validasi_akses($s3s[11], $in{ss});
use HTML::HTMLDoc;

@yesno = ("ALL", "Y","N");
if(!$in{batal}){ $in{batal}='N'; }
($month,$day,$year,$weekday) = &jdate(&today());
$month=substr "0$month",-2;
$pridtoday=$year."-".$month;

print qq~

<style type="text/css">\@import url("/jscalendar/calendar-blue.css");</style>
<script type="text/javascript" src="/jscalendar/calendar.js"></script>
<script type="text/javascript" src="/jscalendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="/jscalendar/calendar-setup.js"></script>

<script type='text/javascript' src='/jquery.min.js'></script>
<script type='text/javascript' src="/jquery.chained.js"></script>

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
      <td align=right width=100>&nbsp; </td>
     <td align=center> <h2 class="hurufcol"> MIS Menyerahkan</h2> </td>
     ~;
if ($s3s[11] eq 'S')
{     print qq~<td align=right width=100>
      <form method=post action="/cgi-bin/sisasset.cgi" >
      <input type="submit" name="back" value="Serah" class="huruf1"/>
      <input name="pages" type="hidden" value=at0017s>
      <input name="ss" type="hidden" value="$in{ss}"> </form> </td> ~;
}     print qq~
     </tr>
     </table>

<form action="/cgi-bin/sisasset.cgi" method="post" name='vq'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at0017>
<table>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp;Tgl Serah </td>
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
    <td class="hurufcol" width=150> &nbsp;Tgl Harus Kembali </td>
    <td class="hurufcol" > <input name="dtk1" type="text" id="dtk1" size="12" maxlength="12" class="huruf1" value="$in{dtk1}" />
        <img src="/jscalendar/img.gif" id="trigger3" style="cursor: pointer; border: 1px solid blue;"
                title="Date selector" onMouseOver="this.style.background='blue';" onMouseOut="this.style.background=''" />
        <script type="text/javascript">
        Calendar.setup(
        {
                inputField  : "dtk1",         // ID of the input field
                ifFormat    : "%m/%d/%Y",    // the date format
                button      : "trigger3"       // ID of the button
	       //daFormat  :  "%Y/%m/%d"
        }
        );
        </script>  s/d   <input name="dtk2" type="text" id="dtk2" size="12" maxlength="12" class="huruf1" value="$in{dtk2}" />
        <img src="/jscalendar/img.gif" id="trigger4" style="cursor: pointer; border: 1px solid blue;"
                title="Date selector" onMouseOver="this.style.background='blue';" onMouseOut="this.style.background=''" />
        <script type="text/javascript">
        Calendar.setup(
        {
                inputField  : "dtk2",         // ID of the input field
                ifFormat    : "%m/%d/%Y",    // the date format
                button      : "trigger4"       // ID of the button
	       //daFormat  :  "%Y/%m/%d"
        }
        );
        </script>
    </td>
    </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp;Cabang Tujuan</td>
    <td class="hurufcol" >
    <input type=text name=cabang id=cabang value="$in{cabang}" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase">
     </td>
    <td class="hurufcol"> &nbsp;Peminjaman </td>
    <td class="hurufcol" > ~;
for ($i=0; $i<@yesno; $i++)
{  $checked="";
   if($in{pinjam} eq $yesno[$i]){ $checked="checked"; }
   print qq~<input type=radio name=pinjam value='$yesno[$i]' $checked/> $yesno[$i] &nbsp; ~;
}
print qq~</td>
    </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp;Karyawan Tujuan</td>
    <td class="hurufcol" >
    <input type=text name=kry id=kry value="$in{kry}" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase">
    </td>
    <td class="hurufcol"> &nbsp;Sudah Kembali</td>
    <td class="hurufcol"> ~;
for ($i=0; $i<@yesno; $i++)
{  $checked="";
   if($in{kembali} eq $yesno[$i]){ $checked="checked"; }
   print qq~<input type=radio name=kembali value='$yesno[$i]' $checked/> $yesno[$i] &nbsp; ~;
}
print qq~</td>
    </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp;Batal </td>
    <td class="hurufcol" > ~;
for ($i=0; $i<@yesno; $i++)
{  $checked="";
   if($in{batal} eq $yesno[$i]){ $checked="checked"; }
   print qq~<input type=radio name=batal value='$yesno[$i]' $checked/> $yesno[$i] &nbsp; ~;
}
print qq~</td>
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
</table>
<input type='submit' name='search' value='Search'>
</form>
~;

if($in{recidsbatal})
{
  $query = $dba1->prepare("
  select kodeinv, cabang_asal, idlama_asal, d.recid, h.dthrskembali, h.dtkirim from kirimd d, kirimh h
    where d.kirimid=h.recid and kirimid=$in{recidsbatal} and d.batal='N' ");
  $query->execute(); $sukses=0;
  $upstokfield = "serah";
  while(@rec = $query->fetchrow_array())
  {
      $q1 = $dba2->do("update inventori set currcabang='$rec[1]', curridlama='$rec[2]', oprupdate='$s3s[0]' where kode='$rec[0]';");

      if($rec[4]){ $upstokfield = "pnjserah"; }
      $jenisinv=substr $rec[0],0,6;
      $rec[5] = genfuncast::formatMDY($rec[5]);
      ($m,$d,$y)=genfuncast::getMdy($rec[5]);
      $m=substr "0$m",-2;
      $periode = $y."-".$m;
      if($q1!=0)
      { $q2 = $dba2->do("update stok set $upstokfield=$upstokfield-1, oprupdate='$s3s[0]' where jenisinv='$jenisinv' ;");
        if($q2!=0){ $sukses++; }
      }
  }
  if($sukses>0)
  {
     $q2 = $dba2->do("update kirimd set batal='Y', oprupdate='$s3s[0]' where kirimid='$in{recidsbatal}' and batal='N';");
     $q3 = $dba2->do("update kirimh set batal='Y', oprupdate='$s3s[0]' where recid='$in{recidsbatal}';");
     if($q2!=0 and $q3!=0) { print qq~<div class=warning_ok>Sukses Batalkan Serah </div> ~; }
     else { print qq~<div class=warning_not_ok>Gagal Batalkan Serah </div> ~; }
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
   { pages.value='at0017se';
     recidh.value=n;
     submit();
   }
}
function toprint(n)
{  with(document.st)
   { pages.value='at0017';
     recidprint.value=n;
     submit();
   }
}
function tobatalserah(n)
{  var result = confirm("Yakin Batalkan Serah ?");
   if (result==true)
   {
      with(document.st)
      { pages.value='at0017';
        recidsbatal.value=n;
        submit();
      }
   }
}
</script>
 $warning_del

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

<FORM ACTION="/cgi-bin/sisasset.cgi" METHOD="post" name='st'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at0017>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <input type=hidden name=recidh value=>
  <input type=hidden name=recidprint value=>
  <input type=hidden name=recidsbatal value=>
  <input type=hidden name=terimabatal value=>
 ~;
}

print qq~
  <table width='1000px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" width=50> No. </td>
   <td align='center' class="hurufcol" width=80> No. Surat  </td>
   <td align='center' class="hurufcol" width=80> Tgl Serah </td>
   <td align='center' class="hurufcol" width=80> Cabang Tujuan  </td>
   <td align='center' class="hurufcol" width=100> Karyawan Tujuan</td>
   <td align='center' class="hurufcol" width=80> Jumlah Inventori </td>
   <td align='center' class="hurufcol" width=80> Tgl Harus Kembali</td>
   <td align='center' class="hurufcol" width=80> Sudah Kembali?</td>
   <td align='center' class="hurufcol" width=80> Action </td>
  </tr>
~;

$subq=""; $subqkirimd="";
if ($in{dtst}) {$subq.=" and dtkirim>='$in{dtst}'"; }
if ($in{dtst2}) {$subq.=" and dtkirim<='$in{dtst2}'"; }
if ($in{pinjam} and  $in{pinjam} ne 'ALL') {$subq.=" and flagpinjam='$in{pinjam}'"; }
if ($in{dtk1}) {$subq.=" and dthrskembali>='$in{dtk1}'"; }
if ($in{dtk2}) {$subq.=" and dthrskembali<='$in{dtk2}'"; }
if ($in{kembali} eq 'Y') {$subq.=" and jml-coalesce(jmlbalik,0)=0  "; }
if ($in{kembali} eq 'N') {$subq.=" and jml-coalesce(jmlbalik,0)>0  "; }
if ($in{jenisinv}) {$subqkirimd.=" and kodeinv like '$in{jenisinv}%'  "; }


if ($in{cabang}) { @cab = split(/\-/,$in{cabang}); $subq.=" and kodecabang='$cab[0]'"; }
if ($in{kry})
{  @kry = split(/\-/,$in{kry});
   $query = $dba1->prepare("select idlama from getkry where nik='$kry[0]'");
   $query->execute();
   @row = $query->fetchrow_array();
   $idlama=$row[0];
   $subq.=" and idlama_tuj='$idlama'";
}
if($in{batal} and $in{batal} ne 'ALL'){ $subq.=" and batal='$in{batal}'"; }

$q = $dba1->prepare("
select nosurat, jenis, dtkirim, namacabang, idlama_tuj, jml, h.recid, h.batal, printke, dthrskembali, coalesce(jmlbalik,0)
from kirimh h
join (select kirimid, count(*) jml from kirimd  where batal='N' $subqkirimd group by kirimid) d on h.recid=d.kirimid
left outer join (select kirimid, count(*) jmlbalik from kirimd where kembaliid is not null and batal='N' group by kirimid) e on h.recid=e.kirimid
join getstruk c on h.cabang_tuj=c.kodecabang where jenis='S' $subq
order by nosurat desc
");
$q->execute();
$no=1;
while (@row = $q->fetchrow_array())
{ $dtk=""; $kembali="";
  if($row[9])
  { $dtk = genfuncast::mdytodmy($row[9]);  $kembali=$row[10];
  }
  
  $btn="";
  if ($s3s[11] eq 'S' )
  { if($row[1] eq 'S' and $row[7] eq 'N')
    { $btn = "
      <a class=iframe  href='asetbox.cgi?display=at0017p&recidprint=$row[6]&ss=$in{ss}'><img src='/images/print.png'></a>&nbsp;";
      if($row[8]==0)
      { $row[2] = genfuncast::formatMDY($row[2]);
        ($m,$d,$y)=genfuncast::getMdy($row[2]);
        $m=substr "0$m",-2;
        $periode = $y."-".$m;
             
        $btn.="<input type='image' src='/images/edit.png' name='edt$no' value='Edit' class='huruf1' onClick=\"toedit('$row[6]');\">&nbsp;";

        if($periode eq $pridtoday)
        { $btn.=" <input type='image' src='/images/del.png' name='batal$no' value='Batal' class='huruf1' onClick=\"tobatalserah('$row[6]');\">"; }
      }
    }
  }

  $dt = genfuncast::mdytodmy($row[2]);
  $nama = "";
  if($row[4]!=0)
  {$query = $dba2->prepare("select nlengkap from getkry where idlama='$row[4]'");
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
     <a class='iframe' href="asetbox.cgi?display=at0017b&sid=$row[6]&ss=$in{ss}">$row[0]</a></td>
     <td align='center' class="hurufcol" valign='top'>$dt</td>
     <td align='center' class="hurufcol" valign='top'>$row[3]</td>
     <td align='center' class="hurufcol" valign='top'>$nama</td>
     <td align='center' class="hurufcol" valign='top'>$row[5]</td>
     <td align='center' class="hurufcol" valign='top'>$dtk</td>
     <td align='center' class="hurufcol" valign='top'>$kembali</td>
     <td align='center' valign='top'>$btn </td>
  </tr>
  ~;
  $no++;
}

print qq ~</table>
Note : Batalkan Penyerahan Hanya Untuk Yang Tgl Penyerahan = Bulan Ini
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

