sub kop026a {

genfuncast::view_header($in{ss}, $s3s[2], 'Tambah pembelian');
genfuncast::validasi_akses($s3s[11], $in{ss});
&koneksi_kop2;

@kondisi = ('B','L');
@kondisitext = ('Baru','Layak');

@flag = ('Y');
@flagtext = ('Yes');

if ($in{action} eq 'add')
{  $in{kode}=~ s/\'/\ /g;
   $in{kode}=~ s/\"/\ /g;
   $in{jen}=~ s/\'/\ /g;
   $in{jen}=~ s/\"/\ /g;
   $in{groupkd} = substr $in{groupkd},0,14;
   
   $subq = "";
   if($in{kodeasset}){ $subq.="or kodeasset='$in{kodeasset}'"; }
   if($in{kodelama}){ $subq.="or kodelama='$in{kodelama}'"; }
   if($in{noseri}){ $subq.="or noseri='$in{noseri}'"; }
   $subq = substr $subq,3;
#   print qq~select kode, currcabang from inventori where kodeasset='$in{kodeasset}' or kodelama='$in{kodelama}'~;
   $query = $dba1->prepare("select kode, currcabang from inventori where $subq ");
   $query->execute();
   @row = $query->fetchrow_array();

   if($row[0])
   { $warning = "<div class='warning_not_ok'>Inventori dengan Kode Asset '$in{kodeasset}' / Kode Lama '$in{kodelama}' / No Seri '$in{noseri}'
     sudah ada yaitu $row[0] di $row[1] </div><br/> ";
   }
   elsif($in{flagasset} eq 'Y' and !$in{kodeasset})
   { $warning = "<div class='warning_not_ok'>Bila Flag Asset di-Cek, Kode Asset harus diisi </div><br/> ";
   }
   elsif ($in{jen} and $in{merek} and $in{noseri} and $in{kondisi} and $in{dtbeli}  and ($in{currcabang} or $in{currkry}))
   {    if (!$in{flagasset}) {$flag="N";}
        else {$flag="Y";}

        @cab=split(/\-/,$in{currcabang});
        $kodecab = $cab[0];
   
        #   print qq~ck = $in{currkry} <br/> ~;
#if  ($in{currkry})
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

       $idlama="0";

       $query = $dba1->prepare("select counter from jenisinv where jenis='$in{jen}' ");
       $query->execute();
       @row = $query->fetchrow_array();
       $ctr = $row[0]+1;
        if($ctr>1000){  }
        elsif($ctr>=100){ $ctr="0".$ctr; }
        elsif($ctr>=10){ $ctr="00".$ctr; }
        else { $ctr="000".$ctr; }
        if($in{dtbeli})
        { $in{dtbeli} = genfuncast::formatMDY($in{dtbeli});
          ($m,$d,$y) = genfuncast::getMdy($in{dtbeli});
          $year = substr $y,-2;
          if($m<10){ $m="0$m"; }
        }
        else { $year='19'; $m='01'; }
        $kode = $in{jen}.$year.$m.$ctr;

       $subkolom="", $subvalue="";
       if ($in{harga}) { $subkolom.=",HARGA";  $subvalue.=",'$in{harga}'"; }
       if ($in{dtbeli}) { $subkolom.=",DTBELI";  $subvalue.=",'$in{dtbeli}'"; }
       if ($in{tipe}) { $subkolom.=",TIPE";  $subvalue.=",'$in{tipe}'"; }
       if ($in{ukuran}) { $subkolom.=",UKURAN";  $subvalue.=",'$in{ukuran}'"; }
       if ($in{kodeasset}) { $subkolom.=",kodeasset";  $subvalue.=",'$in{kodeasset}'"; }
       if ($in{groupkd}) { $subkolom.=",groupkode";  $subvalue.=",'$in{groupkd}'"; }


       $q1 = $dba1->do("
        INSERT INTO INVENTORI (KODE,JENIS,MEREK,KONDISI,KETERANGAN,FLAGASSET,NOSERI,IP,CURRCABANG,CURRIDLAMA,WARNA,KODELAMA,OS,COMPUTERNAME,
        OPRCREATE $subkolom) VALUES
            ('$kode', '$in{jen}', '$in{merek}', '$in{kondisi}','$in{keterangan}', '$flag',
            '$in{noseri}', '$in{ip}','$kodecab', '$idlama', '$in{warna}','$in{kodelama}','$in{os}','$in{computername}','$s3s[0]' $subvalue );");

       if($q1!=0)
       { $q2 = $dba1->do("update jenisinv set counter=counter+1 where jenis='$in{jen}';");

         $jenisinv = $in{jen};
         $in{dtbeli} = genfuncast::formatMDY($in{dtbeli});
         ($m,$d,$y)=genfuncast::getMdy($in{dtbeli});
         $m=substr "0$m",-2;
         $periode = $y."-".$m;

         if ($q2!=0)
         { $q3 = $dba1->do("update stok set masuk = masuk+1, oprupdate='$s3s[0]' where jenisinv='$jenisinv' ;");
           if($q3!=0)
           { $warning = "<div class='warning_ok'>Sukses Add Inventori dengan kode : '$kode'</div><br/> ";
#                $in{jen}='';
#                $in{merek}='';
#                $in{tipe}='';
#                $in{ukuran}='';
#                $in{kondisi}='';
#                $in{keterangan}='';
#                $in{flagasset}='';
#                $in{dtbeli}='';
#                $in{harga}='';
#                $in{noseri}='';
#                $in{ip}='';
#                $in{currcabang}='';
#                $in{currkry}='';
#                $in{warna}='';
#                $in{kodelama}='';
#                $in{os}='';
#                $in{computername}='';
           }
           else { $warning = "<div class='warning_not_ok'>Gagal Add Inventori (3=$q3)</div><br/> "; }
         }
         else { $warning = "<div class='warning_not_ok'>Gagal Add Inventori (2=$q2)</div><br/> "; }
       }
       else { $warning = "<div class='warning_not_ok'>Gagal Add Inventori (1=$q1)</div><br/> "; }

   }
   else { $warning = "<div class='warning_not_ok'>Isilah field-field di bawah dengan benar </div><br/> "; }
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
$query = $dba1->prepare("select kodecabang,namacabang, kodebu from getstruk where (kodecabang like 'MW%') order by kodecabang");
$query->execute(); $i=0;
while (@rec = $query->fetchrow_array())
{  $str.= qq~  { label: "$rec[0]-$rec[1]", category: "$rec[2]" },~ ;
   $pilcab[$i]=$rec[0];
   $pilcabtxt[$i]=$rec[0]." - ".$rec[1];
   $i++;
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
$query = $dba1->prepare("select nik,nlengkap,kodecabang,namacabang from getkry order by kodecabang");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $str.= qq~ { label: "$rec[0] - $rec[1]", category: "$rec[2]" },~ ;
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
$query = $dba1->prepare("SELECT kode, currcabang, curridlama from inventori i
where kode like 'PCDSKT%' order by currcabang");
$query->execute();
while (@rec = $query->fetchrow_array())
{ $nama="";
  if($rec[2])
  {
   $q = $dba2->prepare("SELECT nik, nlengkap from getkry where idlama=$rec[2] ");
   $q->execute();
   @row = $q->fetchrow_array();
   $nama="$row[0] - $row[1]";
  }
  
  $str.= qq~ { label: "$rec[0] - $nama", category: "$rec[1]" },~ ;
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
          { action.value='add';
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
     <td align=center> <h2 class="hurufcol">Tambah Inventori</h2> </td>
     <td align=right width=200>
     &nbsp;
     </td>
     </tr>
     </table>
~;


print qq~
$warning
<script type='text/javascript' src='/jquery.min.js'></script>
<script type='text/javascript' src="/jquery.chained.js"></script>

<style type="text/css">\@import url("/jscalendar/calendar-blue.css");</style>
<script type="text/javascript" src="/jscalendar/calendar.js"></script>
<script type="text/javascript" src="/jscalendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="/jscalendar/calendar-setup.js"></script>

<form action="/cgi-bin/sisasset.cgi" method="post" name='add'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value='at0010a'>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <input name="action" type="hidden" value=''>
  <table width='880px' border='0' cellspacing='2' cellpadding='2'>

  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120 valign=top>&nbsp;Jenis Inventori * </td>
    <td class="hurufcol" bgcolor=$colcolor2><select name="jen" class="huruf1" id="jen">
    <option value=''>-</option>~;
$query = $dba1->prepare("SELECT jenis,namajenis FROM JENISINV ORDER BY namajenis");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $selected="";
   if ($in{jen} eq $rec[0]) { $selected="selected"; }
   print qq~<option value='$rec[0]' $selected> $rec[1] </option>~;
}
print qq~
    </select>
    
 <br/>Flag Asset
 ~;
  $checked=""; $vis="hidden";
  if ($in{flagasset} eq  'Y') {$checked="checked"; $vis="visible"; }
  print qq~<input type=checkbox name=flagasset value='Y' class=huruf1 $checked
  onchange="if(this.checked){ document.getElementById('kda').style.visibility='visible';}
  else {document.getElementById('kda').style.visibility='hidden';} "> Yes &nbsp; &nbsp; &nbsp;
  <div name='kda' id='kda' style='visibility:$vis'>   Kode Asset:
  <input type=text name=kodeasset id=kodeasset value='$in{kodeasset}' class= keyboardInput maxlength="10" size=12 >
  </div>
   ~;

print qq~

    </td>
  </tr>
  
<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120 valign=top>&nbsp;Group Kode </td>
    <td class="hurufcol" bgcolor=$colcolor2>
     <input type=text name=groupkd id=groupkd value="$in{groupkd}" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase">
    </td>
</tr>

<tr bgcolor=$colcolor height=20>
     <td class="hurufcol" >&nbsp;Merek *</td>
    <td class="hurufcol" bgcolor=$colcolor2><select name="merek" class="huruf1" id="merek">
    <option value=''>-</option>~;
$query = $dba1->prepare("SELECT merek,namamerek FROM merek ORDER BY namamerek ");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $selected="";
   if ($in{merek} eq $rec[0]) { $selected="selected"; }
   print qq~<option value='$rec[0]' $selected> $rec[1]</option>~;
}
print qq~

</select>
    </td>
</tr>


<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150>&nbsp;Model / Tipe</td>
    <td class="hurufcol" bgcolor=$colcolor2><select name="tipe" class="huruf1" id="tipe">
    <option value=''>-</option>~;
$query = $dba1->prepare("SELECT tipe,namatipe,jenis FROM TIPEINV ORDER BY tipe");
$query->execute();
while (@rec2 = $query->fetchrow_array())
{  $selected="";
   if ($in{tipe} eq $rec2[0]) { $selected="selected"; }
   print qq~<option value='$rec2[0]' $selected class='$rec2[2]'>$rec2[0] </option>~;
}
print qq~
    </select>
    </td>
  </tr>
  
<tr bgcolor=$colcolor height=20>
     <td class="hurufcol" >&nbsp;Ukuran</td>
    <td class="hurufcol" bgcolor=$colcolor2><select name="ukuran" class="huruf1" id="ukuran">
    <option value=''>-</option>~;
$query = $dba1->prepare("SELECT ukuran,namaukuran FROM  ukuraninv ORDER BY namaukuran ");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $selected="";
   if ($in{ukuran} eq $rec[0]) { $selected="selected"; }
   print qq~<option value='$rec[0]' $selected class> $rec[1]  </option>~;
}
print qq~

</select>
    </td>
</tr>

<tr bgcolor=$colcolor height=20>
     <td class="hurufcol" >&nbsp;Warna</td>
    <td class="hurufcol" bgcolor=$colcolor2><select name="warna" class="huruf1" id="warna">
    <option value=''>-</option>~;
$query = $dba1->prepare("SELECT warna,namawarna FROM warna ORDER BY namawarna ");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $selected="";
   if ($in{warna} eq $rec[0]) { $selected="selected"; }
   print qq~<option value='$rec[0]' $selected> $rec[1]</option>~;
}
print qq~

</select>
    </td>
</tr>

  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150>&nbsp;Nomor Seri * </td>
    <td class="hurufcol" bgcolor=$colcolor2><input type=text name=noseri value='$in{noseri}'  maxlength="30">
   &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;  Kode Lama
        <input type=text name=kodelama value='$in{kodelama}' class= keyboardInput maxlength="20">
    </td>
  </tr>

<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150>&nbsp;Kondisi *</td>
    <td class="hurufcol" bgcolor=$colcolor2>~;
for ($i=0; $i<@kondisi; $i++)
{ $checked="";
  if ($in{kondisi} eq  $kondisi[$i]) { $checked="checked";}
  if ($record[1] eq  $kondisi[$i]) { $checked="checked";}
  print qq~<input type=radio name=kondisi value='$kondisi[$i]' class=huruf1 $checked> $kondisitext[$i] &nbsp; &nbsp; &nbsp; ~;
}
print qq~
</td>
  </tr>

<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150>&nbsp;Keterangan</td>
    <td class="hurufcol" bgcolor=$colcolor2><input type=text name=keterangan value='$in{keterangan}' class= keyboardInput size=35 maxlength="30">
    </td>
</tr>

<tr bgcolor=$colcolor height=20>
<td class="hurufcol">&nbsp;Tanggal Beli *</td>
<td class="hurufcol" bgcolor=$colcolor2> <input name="dtbeli" type="text" id="dtbeli" size="12" maxlength="12" class="huruf1" value="$in{dtbeli}" />
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
    <td class="hurufcol" width=150>&nbsp;Harga</td>
    <td class="hurufcol" bgcolor=$colcolor2><input type=text name=harga value='$in{harga}' class= keyboardInput maxlength="15">
    </td>
  </tr>

 <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp;Nama Karyawan </td>
    <td class="hurufcol" bgcolor=$colcolor2>
<!--<input type=text name=currkry id=currkry value="$in{currkry}" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase"> -->
      &nbsp; &nbsp; &nbsp;  &nbsp; &nbsp; &nbsp;  &nbsp; &nbsp; &nbsp;   / Cabang Store *
      <select name=currcabang id=currcabang>
      <option value=''>-</option>
~;
for ($i=0; $i<@pilcab; $i++)
{  print qq~<option value='$pilcab[$i]'>$pilcabtxt[$i]</option>~;
}
print qq~
      </select>
<!--    <input type=text name=currcabang id=currcabang value="$in{currcabang}" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase">-->
     </td>
    </tr>

 <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Computer Name</td>
    <td class="hurufcol" bgcolor=$colcolor2><input type=text name=computername value='$in{computername}' class= keyboardInput maxlength="20">
     &nbsp; &nbsp; &nbsp; IP
 <input type=text name=ip value='$in{ip}' class= keyboardInput maxlength="15">
      &nbsp; &nbsp; &nbsp; OS
      <input type=text name=os value='$in{os}' class= keyboardInput maxlength="20">
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

