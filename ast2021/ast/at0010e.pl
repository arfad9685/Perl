sub at0010e {

genfuncast::view_header($in{ss}, $s3s[2], 'Edit Inventori');
genfuncast::validasi_akses($s3s[11], $in{ss}, 'S');
&koneksi_ast2;

@kondisi = ('B','L');
@kondisitext = ('Baru','Layak');

@flag = ('Y');
@flagtext = ('Yes');


if ($in{action} eq 'edit')
{

   $in{kd}=~ s/\'/\ /g;
   $in{kd}=~ s/\"/\ /g;
   $in{namajenis}=~ s/\'/\ /g;
   $in{namajenis}=~ s/\"/\ /g;
   $in{namamerek}=~ s/\'/\ /g;
   $in{namamerek}=~ s/\"/\ /g;
   $in{flagasset}=~ s/\'/\ /g;
   $in{flagasset}=~ s/\"/\ /g;
   $in{kondisi}=~ s/\'/\ /g;
   $in{kondisi}=~ s/\"/\ /g;
   $in{currcabang}=~ s/\'/\ /g;
   $in{currcabang}=~ s/\"/\ /g;
   
   $subq = "";
   if($in{kodeasset}){ $subq.="or kodeasset='$in{kodeasset}'"; }
   if($in{kodelama}){ $subq.="or kodelama='$in{kodelama}'"; }
   if($in{noseri}){ $subq.="or noseri='$in{noseri}'"; }
   $subq = substr $subq,3;
   $query = $dba1->prepare("select kode, currcabang from inventori where ($subq)
        and kode!='$in{kd}' ");
   $query->execute();
   @row = $query->fetchrow_array();

   if($row[0])
   { $warning = "<div class='warning_not_ok'>Inventori dengan Kode Asset '$in{kodeasset}' / Kode Lama '$in{kodelama}' / No Seri '$in{noseri}'
     sudah ada yaitu $row[0] di $row[1] </div><br/> ";
   }
   elsif($in{flagasset} eq 'Y' and !$in{kodeasset})
   { $warning = "<div class='warning_not_ok'>Bila Flag Asset di-Cek, Kode Asset harus diisi </div><br/> ";
   }
elsif ($in{jen} and $in{merek} and $in{kondisi} and $in{currcabang})
{

     if (!$in{flagasset}) {$flag="N";}
     else {$flag="Y";}

     $subquery="";
        if ($in{harga}) { $subquery.=",HARGA='$in{harga}'";}
        if ($in{dtbeli}) { $subquery.=",DTBELI='$in{dtbeli}'";}
        if ($in{tipe}) { $subquery.=",TIPE='$in{tipe}'";}
        if ($in{ukuran}) { $subquery.=",UKURAN='$in{ukuran}'";}
        if ($in{kodeasset} and $flag eq 'Y') { $subquery.=",kodeasset='$in{kodeasset}'";}
        if ($flag eq 'N') { $subquery.=",kodeasset=''";}
        #if ($in{groupkd}) #supaya bisa hapus kodenya kalau kosong
        { $in{groupkd}=substr $in{groupkd},0,14; $subquery.=", groupkode='$in{groupkd}'";}

@cab=split(/\-/,$in{currcabang});
 $kodecab = $cab[0];
   
# if  ($in{currkry})
#   {
#   @kry=split(/\-/,$in{currkry});
#   $nik = $kry[0];
#   #print "$in{currkry} select idlama from getkry where nik='$nik'";
#    $query = $dba1->prepare("select idlama, kodecabang from getkry where nik='$nik'");
#       $query->execute();
#       @row = $query->fetchrow_array();
#       $idlama=$row[0];
#       $in{currcabang}=$row[1];
#     }
#     else { $idlama="0"; }

if ($in{kd})
   {
    $postall = $dba1->do("
    UPDATE INVENTORI SET jenis='$in{jen}',merek='$in{merek}',noseri='$in{noseri}',kondisi='$in{kondisi}',keterangan='$in{keterangan}',
    flagasset='$flag',ip='$in{ip}',warna='$in{warna}',kodelama='$in{kodelama}',os='$in{os}',
    computername='$in{computername}',oprupdate='$s3s[0]' $subquery WHERE kode='$in{kd}';");
    #,currcabang='$kodecab',curridlama='$idlama' --> berubahnya harus lewat serah terima
            
    if($postall!=0) {   $warning = "<div class='warning_ok'>Sukses Edit Inv</div><br/> "; }
    else {   $warning = "<div class='warning_not_ok'>Gagal Edit Inv</div><br/> "; }

   }
   else { $warning = "<div class='warning_not_ok'>Isilah field-field di bawah dengan benar </div><br/> "; }

}
}

print qq~
<!--<script type='text/javascript' src='/jquery.min.js'></script>-->
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
$query = $dba1->prepare("select kodecabang,namacabang, kodebu from getstruk where (kodecabang like 'C%' or kodecabang like 'MW%') order by kodecabang");
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
#$query = $dba1->prepare("SELECT kode, currcabang, nik, nlengkap  from inventori i left outer join getkry k
#on i.curridlama=k.idlama where kode like 'PCDSKT%' order by currcabang");
#$query->execute();
#while (@rec = $query->fetchrow_array())
#{  $str.= qq~ { label: "$rec[0] - $rec[2] - $rec[3]", category: "$rec[1]" },~ ;
#}

$query = $dba1->prepare("SELECT kode, currcabang, curridlama  from inventori i where kode like 'PCDSKT%' order by currcabang");
$query->execute();
while (@rec = $query->fetchrow_array())
{ $kry="";
  if($rec[2])
  {
    $q2 = $dba2->prepare("SELECT nik, nlengkap from getkry where idlama = $rec[2]");
    $q2->execute();
    @rec2 = $q2->fetchrow_array();
    $kry = $rec[2]." - ".$rec[3];
  }
  
  $str.= qq~ { label: "$rec[0] - $kry", category: "$rec[1]" },~ ;
}
$n = length($str) - 1;
$str = substr $str,0,$n;

print qq~
      $str
    ];

    \$("#groupkd").catcomplete({
      delay: 0,
      source: data3
    });
  });
  </script>
<script type="text/javascript">
function toSubmit()
{  var result = confirm("Yakin Simpan Inventori?");
        if (result==true) {
         with(document.add)
          { action.value='edit';
             submit();
          }
         }
}
</script>
~;


print qq~
<div class="container">
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=200>
     <form method=post action="/cgi-bin/sisasset.cgi" >
      <input type="submit" name="back" value="BACK" class="huruf1"/>
      <input name="pages" type="hidden" value=at0010>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
     </td>
     <td align=center> <h2 class="hurufcol">Edit Inventori</h2> </td>
     <td align=right width=200>
     &nbsp;
     </td>
     </tr>
     </table>
     $warning
~;
#print("select i.kode,i.jenis,i.tipe,i.ukuran,i.merek,i.noseri,i.kondisi,i.keterangan,i.flagasset,i.dtbeli,i.harga,
#    i.ip,i.currcabang||'-'||s.namacabang as currcabang,k.nik||'-'||k.nlengkap as curridlama,i.warna,i.kodelama,i.os,i.computername
#from inventori i
#left outer join getstruk s on i.currcabang=s.kodecabang
#left outer join getkry k on i.curridlama=k.idlama
#where i.kode='$in{kd}' ");

$query = $dba1->prepare("select i.kode,i.jenis,i.tipe,i.ukuran,i.merek,i.noseri,i.kondisi,i.keterangan,i.flagasset,i.dtbeli,i.harga,
    i.ip,i.currcabang||'-'||s.namacabang as currcabang, curridlama,i.warna,i.kodelama,i.os,i.computername, i.currcabang, i.kodeasset, groupkode
from inventori i
 join getstruk s on i.currcabang=s.kodecabang
where i.kode='$in{kd}' ");
$query->execute();
@record = $query->fetchrow_array();
#k.nik||'-'||k.nlengkap

if($record[13])
{
  $q2 = $dba1->prepare("select nik, nlengkap from getkry where idlama=$record[13]  ");
  $q2->execute();
  @rec = $q2->fetchrow_array();
  $record[13] = $rec[0]."-".$rec[1];
}

if ($record[1] eq 'W') { $record[1]='Y'; }
print qq~

<script type='text/javascript' src='/jquery.min.js'></script>
<script type='text/javascript' src="/jquery.chained.js"></script>

<style type="text/css">\@import url("/jscalendar/calendar-blue.css");</style>
<script type="text/javascript" src="/jscalendar/calendar.js"></script>
<script type="text/javascript" src="/jscalendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="/jscalendar/calendar-setup.js"></script>

<form action="/cgi-bin/sisasset.cgi" method="post" name='add'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=action value=''>
  <input type=hidden name=pages value=at0010e>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <input type=hidden name=kd value=$in{kd}>
  <input type=hidden name=jen value=$record[1]>
  <input type=hidden name=currcabang value=$record[18]>
  <table width='840px' border='0' cellspacing='2' cellpadding='2'>
<tr bgcolor=$colcolor height=20>
    <td class="hurufcol">&nbsp;Kode Inventori </td>
    <td class="hurufcol" bgcolor=$colcolor2> $in{kd}
    </td>
</tr>

<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120 valign=top>&nbsp;Group Kode </td>
    <td class="hurufcol" bgcolor=$colcolor2>
     <input type=text name=groupkd id=groupkd value="$record[20]" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase">
    </td>
</tr>

<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120 valign=top>&nbsp;Jenis Inventori </td>

    ~;
$query = $dba1->prepare("SELECT jenis,namajenis FROM JENISINV  where jenis='$record[1] ' ORDER BY namajenis");
$query->execute();
@rec1 = $query->fetchrow_array();
   print qq~  <td class="hurufcol" bgcolor=$colcolor2> $rec1[1]  <br/>Flag Asset ~;
  $checked=""; $vis="hidden";
  if ($record[8] eq  'Y') {$checked="checked"; $vis="visible"; }
  print qq~<input type=checkbox name=flagasset value='Y' class=huruf1 $checked
  onchange="if(this.checked){ document.getElementById('kda').style.visibility='visible';}
  else {document.getElementById('kda').style.visibility='hidden';} "> Yes &nbsp; &nbsp; &nbsp;
  <div name='kda' id='kda' style='visibility:$vis'>   Kode Asset:
  <input type=text name=kodeasset id=kodeasset value='$record[19]' class=keyboardInput maxlength="10" size=12 >
  </div>
   ~;
print qq~
    </td>
</tr>
  
<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Merek </td>
    <td class="hurufcol" bgcolor=$colcolor2><select name="merek" class="huruf1" id="merek">
    <option value=''>-</option>~;
$query = $dba1->prepare("SELECT merek,namamerek FROM merek ORDER BY namamerek");
$query->execute();
while (@rec4 = $query->fetchrow_array())
{  $selected="";
   if ($record[4] eq $rec4[0]) { $selected="selected"; }
   print qq~<option value='$rec4[0]' $selected> $rec4[1] </option>~;
}
print qq~
    </select>
    </td>
</tr>
  
<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Model / Tipe </td>
    <td class="hurufcol" bgcolor=$colcolor2><select name="tipe" class="huruf1" id="tipe">
    <option value=''>-</option>~;
$query = $dba1->prepare("SELECT tipe,namatipe,jenis FROM TIPEINV where jenis='$record[1]' ORDER BY tipe");
$query->execute();
while (@rec2 = $query->fetchrow_array())
{  $selected="";
   if ($record[2] eq $rec2[0]) { $selected="selected"; }
   print qq~<option value='$rec2[0]' $selected class='$rec2[2]'>$rec2[0] </option>~;
}
print qq~
    </select>
    </td>
</tr>
  
<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Ukuran </td>
    <td class="hurufcol" bgcolor=$colcolor2><select name="ukuran" class="huruf1" id="ukuran">
    <option value=''>-</option>~;
$query = $dba1->prepare("SELECT ukuran,namaukuran FROM UKURANINV ORDER BY namaukuran");
$query->execute();
while (@rec3 = $query->fetchrow_array())
{  $selected="";
   if ($record[3] eq $rec3[0]) { $selected="selected"; }
   print qq~<option value='$rec3[0]' $selected class>$rec3[1] </option>~;
}
print qq~
    </select>
    </td>
</tr>

<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Warna </td>
    <td class="hurufcol" bgcolor=$colcolor2><select name="warna" class="huruf1" id="warna">
    <option value=''>-</option>~;
$query = $dba1->prepare("SELECT warna,namawarna FROM warna ORDER BY namawarna");
$query->execute();
while (@rec5 = $query->fetchrow_array())
{  $selected="";
   if ($record[14] eq $rec5[0]) { $selected="selected"; }
   print qq~<option value='$rec5[0]' $selected> $rec5[1] </option>~;
}
print qq~
    </select>
    </td>
</tr>
  
<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Nomor Seri </td>
    <td class="hurufcol" bgcolor=$colcolor2><input type=text name=noseri value='$record[5]' class=huruf1 maxlength="30">
    &nbsp; &nbsp; &nbsp; Kode Lama
    <input type=text name=kodelama value='$record[15]' class= keyboardInput maxlength="20">
    </td>
</tr>
  
<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Kondisi </td>
<td class="hurufcol" bgcolor=$colcolor2>~;
for ($i=0; $i<@kondisi; $i++)
{ $checked="";
#  if ($in{kondisi} eq  $kondisi[$i]) { $checked="checked";}
  if ($record[6] eq  $kondisi[$i]) { $checked="checked";}
  print qq~<input type=radio name=kondisi value='$kondisi[$i]' class=huruf1 $checked> $kondisitext[$i] &nbsp; &nbsp; &nbsp; ~;
}
print qq~
</td>
</tr>
  
<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Keterangan </td>
    <td class="hurufcol" bgcolor=$colcolor2><input type=text name=keterangan value='$record[7]' class=huruf1 size=35 maxlength="30">
    </td>
</tr>
  
<tr bgcolor=$colcolor height=20>
   <td class="hurufcol">&nbsp;Tanggal Beli</td>
   <td class="hurufcol" bgcolor=$colcolor2> <input name="dtbeli" type="text" id="dtbeli" size="12" maxlength="12" class="huruf1" value="$record[9]" />
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


        </script>
</td>
</tr>

<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Harga </td>
    <td class="hurufcol" bgcolor=$colcolor2 ><input type=text name=harga value='$record[10]' class=huruf1 maxlength="20">
    </td>
  </tr>
  
<tr bgcolor=$colcolor height=20>
    <td class="hurufcol">&nbsp;Nama Karyawan </td>
    <td class="hurufcol" bgcolor=$colcolor2> $record[13]
     &nbsp; &nbsp; &nbsp;
     /&nbsp;&nbsp; Cabang Store : $record[12]
     </td>
</tr>
  
<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Computer Name</td>
    <td class="hurufcol" bgcolor=$colcolor2><input type=text name=computername value='$record[17]' class= keyboardInput maxlength="20">
     &nbsp; &nbsp; &nbsp; IP
    <input type=text name=ip value='$record[11]' class=huruf1 maxlength="20">
    &nbsp; &nbsp; &nbsp; OS
    <input type=text name=os value='$record[16]' class= keyboardInput maxlength="20">
    </td>
</tr>

</table>
<script language="javascript" >
\$("#tipe").chained("#jen");
</script>

 <input type=button value='Simpan' name="simpan" class="huruf1" onClick="toSubmit();">
</form>
    <hr width="100" />
</center>~;
}


1

