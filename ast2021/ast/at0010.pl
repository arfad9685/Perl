sub at0010 {

&koneksi_ast2;

genfuncast::view_header($in{ss}, $s3s[2], 'Master Inventori');
genfuncast::validasi_akses($s3s[11], $in{ss});

@cab=split(/\-/,$in{currcabang});
   $kodecab = $cab[0];
   
if  ($in{currkry})
   {
   @kry=split(/\-/,$in{currkry});
   $nik = $kry[0];
   #print "$in{currkry} select idlama from getkry where nik='$nik'";
   $query = $dba1->prepare("select idlama from getkry where nik='$nik'");
   $query->execute();
   @row = $query->fetchrow_array();
   $idlama=$row[0];
   }
    else { $idlama="0";
    }

print qq~
<!--<script type='text/javascript' src='/jquery.min.js'></script>-->

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


    \$("#currcabang").catcomplete({
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

    \$("#currkry").catcomplete({
      delay: 0,
      source: data2
    });
  });
  </script>
  

  <script>
  \$(function(\$) {
    var data3 = [
~;
$str="";
$query = $dba1->prepare("select kode, merek, namajenis from inventori i, jenisinv j where i.jenis=j.jenis order by kode");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $str.= qq~ { label: "$rec[0]-$rec[1]", category: "$rec[2]" },~ ;
}
$n = length($str) - 1;
$str = substr $str,0,$n;

print qq~
      $str
    ];

    \$("#kodeinv").catcomplete({
      delay: 0,
      source: data3
    });
  });
  </script>
  ~;

print qq~
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=150>
     &nbsp;
     </td>
     <td align=center> <h2 class="hurufcol"> MASTER INVENTORI</h2> </td>
     ~;
#if ($s3s[11] eq 'S')
{     print qq~<td align=right width=100>
        <form method=post action="/cgi-bin/sisasset.cgi" >
      <input type="submit" name="back" value="Tambah PC" class="huruf1"/>
      <input name="pages" type="hidden" value=at0010a2>
      <input name="ss" type="hidden" value="$in{ss}"> </form> </td>
      <td align=right width=50>
        <form method=post action="/cgi-bin/sisasset.cgi" >
      <input type="submit" name="back" value="Tambah" class="huruf1"/>
      <input name="pages" type="hidden" value=at0010a>
      <input name="ss" type="hidden" value="$in{ss}"> </form> </td>~;
}     print qq~
     </tr>
     </table>
<form action="/cgi-bin/sisasset.cgi" method="post" name='vq'>
<input type=hidden name=ss value="$in{ss}">
<input type=hidden name=pages value=at0010>
<table>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> &nbsp;Jenis Inventori </td>
    <td class="hurufcol" ><select name="jen" class="huruf1" id="jen">
    <option value=''>-</option>~;
$query = $dba1->prepare("SELECT jenis,namajenis FROM JENISINV ORDER BY namajenis ");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $selected="";
   if ($in{jen} eq $rec[0]) { $selected="selected"; }
   print qq~<option value='$rec[0]' $selected> $rec[1] </option>~;
}
print qq~
    </select>
    </td>
    <td class="hurufcol" width=100> &nbsp;Kode Inventori </td>
    <td class="hurufcol" >
    <input type=text name=kodeinv id=kodeinv value="$in{kodeinv}" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase">
    </td>
</tr>
<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> &nbsp;Cabang </td>
    <td class="hurufcol" >
    <input type=text name=currcabang id=currcabang value="$in{currcabang}" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase">
     </td>
    <td class="hurufcol" width=100> &nbsp;Kode Asset </td>
    <td class="hurufcol" >
    <input type=text name=kodeasset id=kodeasset value="$in{kodeasset}" class=huruf1 size=12 maxlength="10" style="text-transform: uppercase">
    </td>
</tr>
<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> &nbsp;Karyawan </td>
    <td class="hurufcol" >
    <input type=text name=currkry id=currkry value="$in{currkry}" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase">
    </td>
    <td class="hurufcol" width=150>&nbsp;Kode Lama  </td>
    <td class="hurufcol"><input type=text name=kdlama value='$in{kdlama}'  maxlength="30">
    </td>
</tr>
<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=100> &nbsp;Tanggal Beli </td>
    <td class="hurufcol" >
     <input name="dtbeli" type="text" id="dtbeli" size="12" maxlength="12" class="huruf1" value="$in{dtbeli}" />
        <img src="/jscalendar/img.gif" id="trigger1" style="cursor: pointer; border: 1px solid blue;"
                title="Date selector" onMouseOver="this.style.background='blue';" onMouseOut="this.style.background=''" />
        <script type="text/javascript">
        Calendar.setup(
        {
                inputField  : "dtbeli",         // ID of the input field
                ifFormat    : "%m/%d/%Y",    // the date format
                button      : "trigger1"       // ID of the button
	       //daFormat  :  "%Y/%m/%d"
        }
        );
        </script> s.d <input name="dtbeli2" type="text" id="dtbeli2" size="12" maxlength="12" class="huruf1" value="$in{dtbeli2}" />
        <img src="/jscalendar/img.gif" id="trigger2" style="cursor: pointer; border: 1px solid blue;"
                title="Date selector" onMouseOver="this.style.background='blue';" onMouseOut="this.style.background=''" />
        <script type="text/javascript">
        Calendar.setup(
        {
                inputField  : "dtbeli2",         // ID of the input field
                ifFormat    : "%m/%d/%Y",    // the date format
                button      : "trigger2"       // ID of the button
	       //daFormat  :  "%Y/%m/%d"
        }
        );
        </script>
    </td>
    <td class="hurufcol" width=150>&nbsp;Nomor Seri  </td>
    <td class="hurufcol"><input type=text name=noseri value='$in{noseri}'  maxlength="30">
    </td>
    </tr>
</table>
 
<table>
<tr>
    <td align=center><input type='submit' name='search' value='Search'> </td>
  </tr>
</table>
</form>
~;


if ($s3s[11] eq 'S')
{
print qq ~
<script type="text/javascript">
function validasi(n)
{
      var result = confirm("Are you sure to delete?");
        if (result==true) {
          with(document.mst)
          { pages.value='at0010';
            kd.value=n;
           submit();
          }
        }
}
function validasi2(n)
{
      var result = confirm("Are you sure to delete?");
        if (result==true) {
          with(document.mst)
          { pages.value='at0010';
            child.value=n;
           submit();
          }
        }
}
function toedit(n)
{  with(document.mst)
   { pages.value='at0010e';
     kd.value=n;
     submit();
   }
}
function toaddsub(n)
{  with(document.mst)
   { pages.value='at0010b';
     kd.value=n;
     submit();
   }
}
</script>
 $warning_del
   <FORM ACTION="/cgi-bin/sisasset.cgi" METHOD="post" name='mst'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at0010>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
 <input type=hidden name='kd'>
 <input type=hidden name='child'>
 <input type=hidden name='parent'>
 <input type=hidden name='action' value='delete'>
 ~;
}

if($in{search} or $in{jen})
{
print qq~
<script type='text/javascript' src='/jquery.min.js'></script>
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
<table width='1200px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" width=50> No. </td>
   <td align='left' class="hurufcol" width=100> Kode </td>
   <td align='left' class="hurufcol" width=100> Kode Asset </td>
   <td align='left' class="hurufcol" width=100> Kode Lama </td>
   <td align='left' class="hurufcol" width=100> Jenis </td>
   <td align='left' class="hurufcol" width=100> Merek </td>
   <td align='left' class="hurufcol" width=100> Warna </td>
   <td align='left' class="hurufcol" width=80> Model/Tipe </td>
   <td align='left' class="hurufcol" width=50> Ukuran </td>
   <td align='left' class="hurufcol" width=50> Flag Asset </td>
   <td align='left' class="hurufcol" width=60> Kondisi</td>
   <td align='left' class="hurufcol" width=50> No Seri</td>
   <td align='left' class="hurufcol" width=50> IP</td>
   <td align='left' class="hurufcol" width=200> Cabang </td>
   <td align='left' class="hurufcol" width=250> Karyawan </td>
   <td align='left' class="hurufcol" width=200> Created By </td>
   <td align='left' class="hurufcol" width=70> Action</td>
  </tr>
~;

$subq="";
@inv=split(/\-/,$in{kodeinv});
if ($in{jen}) {$subq.=" and i.jenis='$in{jen}'"; }
if ($in{currcabang}) {$subq.=" and i.currcabang='$kodecab'"; }
if ($in{currkry}){$subq.=" and i.curridlama='$idlama'"; }
if ($in{dtbeli}){  $subq.=" and i.dtbeli >= '$in{dtbeli}'"; }
if ($in{dtbeli2}) {$subq.=" and i.dtbeli<='$in{dtbeli2}'"; }
if ($in{kodeasset})  { $in{kodeasset} = uc $in{kodeasset}; $subq.=" and i.kodeasset like '%$in{kodeasset}%'"; }
if ($in{noseri}) { $in{noseri} = uc $in{noseri}; $subq.=" and i.noseri like '%$in{noseri}%'"; }
if ($in{kdlama}) { $in{kdlama} = uc $in{kdlama}; $subq.=" and i.kodelama like '%$in{kdlama}%'"; }

if ($in{kodeinv})
{ $huruf6 = substr $inv[0],0,6;
  if($huruf6 eq 'PCDSKT'){ $subq.=" and (i.kode='$inv[0]' or groupkode='$inv[0]')"; }
  else { $subq.=" and i.kode='$inv[0]'"; }
}

$subq = substr $subq,5;
if ($subq) {$subq = "where $subq ";}

#$q = $dba1->prepare("select i.kode,j.namajenis,m.namamerek,w.namawarna,t.tipe,u.namaukuran,i.flagasset,i.kondisi,i.noseri,i.ip,s.namacabang,
#k.nlengkap,k.nik,i.oprcreate,i.kodelama,i.os,i.computername, i.kodeasset
#from inventori i
#left outer join jenisinv j on i.jenis=j.jenis
#left outer join merek m on i.merek=m.merek
#left outer join tipeinv t on i.tipe=t.tipe
#left outer join ukuraninv u on i.ukuran=u.ukuran
#left outer join warna w on i.warna=w.warna
#left outer join getstruk s on s.kodecabang=i.currcabang
#left outer join getkry k on k.idlama=i.curridlama
#$subq order by j.jenis, i.dtcreate desc");

$q = $dba1->prepare("select i.kode,j.namajenis,m.namamerek,w.namawarna,t.tipe,u.namaukuran,i.flagasset,i.kondisi,i.noseri,i.ip,s.namacabang,
k.nlengkap,k.nik,i.oprcreate,i.kodelama,i.os,i.computername, i.kodeasset
from inventori i
left outer join jenisinv j on i.jenis=j.jenis
left outer join merek m on i.merek=m.merek
left outer join tipeinv t on i.tipe=t.tipe
left outer join ukuraninv u on i.ukuran=u.ukuran
left outer join warna w on i.warna=w.warna
left outer join getstruk s on s.kodecabang=i.currcabang
left outer join getkry k on k.idlama=i.curridlama
$subq order by j.jenis, i.dtcreate desc");
$q->execute();

#$q2 = $dba2->prepare("select k.idlama,k.nik,k.nlengkap from inventori i left outer join getkry k on k.idlama=i.curridlama $subq2 ");
#$q2->execute();

$no=1;
$tmpkat = '';
while (@row = $q->fetchrow_array())
{

# foreach (@row2 = $q2->fetchrow_array())
# {if ($s3s[11] eq 'S' and $row2[0] ne $row2[2])
#  { $btn2 = "
#    <input type='image' src='/images/edit.png' name='edt$no' value='Edit' class='huruf1' onClick=\"toedit('$row[0]');\">&nbsp;"; }
#  else { $btn2=""; }
#  }
 
{if ($s3s[11] eq 'S')
  { $btn = "
    <input type='image' src='/images/edit.png' name='edt$no' value='Edit' class='huruf1' onClick=\"toedit('$row[0]');\">&nbsp;"; }
  else { $btn=""; }
  }

#  if($row[11])
#  {
#   $q2 = $dba2->prepare("SELECT nik, nlengkap from getkry where idlama=$row[11] ");
#   $q2->execute();
#   @rec = $q2->fetchrow_array();
#   $nik=$rec[0];
#   $nlengkap=$rec[1];
#  }
  
  if($no%2==1){ $bg=$colcolor; }
  else { $bg=$colcolor2; }
  print qq~
  <tr bgcolor=$bg height=20>
     <td align='center' class="hurufcol" valign="top">$no </td>
     <td class="hurufcol" valign="top"><a class='iframe' href="asetbox.cgi?display=at0010b&kd=$row[0]&ss=$in{ss}">$row[0]</a></td>
     <td class="hurufcol" valign="top">$row[17]</td>
     <td class="hurufcol" valign="top">$row[14]</td>
     <td class="hurufcol" valign="top">$row[1]</td>
     <td class="hurufcol" valign="top">$row[2]</td>
     <td class="hurufcol" valign="top">$row[3]</td>
     <td class="hurufcol" valign="top">$row[4]</td>
     <td class="hurufcol" valign="top">$row[5]</td>
     <td class="hurufcol" valign="top">$row[6]</td>
     <td class="hurufcol" valign="top">$row[7]</td>
     <td class="hurufcol" valign="top">$row[8]</td>
     <td class="hurufcol" valign="top">$row[9]</td>
     <td class="hurufcol" valign="top">$row[10]</td>
     <td class="hurufcol" valign="top">$row[12] - $row[11]</td>
     <td class="hurufcol" valign="top">$row[13]</td>
     <td align='center' valign="top">$btn </td>

  </tr>
  ~;
  $no++;
  $tmpkat=$row[0];
}

print qq ~</table>
~;
}

if ($s3s[11] eq 'S')
{  print qq ~</form>~;
}
print qq ~
    <hr width="100" />
</center>
~;
}

;
1

