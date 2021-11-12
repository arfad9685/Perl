sub at0014c {

genfuncast::view_header($in{ss}, $s3s[2], 'Create Opname');
genfuncast::validasi_akses($s3s[11], $in{ss}, 'S');

@kondisi = ('L','R','W');
@kondisitext = ('Layak','Rusak','Waste');

@kondisi1 = ('L','R');
@kondisitext1 = ('Layak','Rusak');


@flag = ('A','T');
@flagtext = ('Asset','Attribut');

if ($in{simpan})
{  $sukses=0;
   if(!$in{dtop}) { $wrn = "<li>Tgl Opname harus diisi</li>"; }
   if(!$in{cabang}) { $wrn = "<li>Cabang harus diisi</li>"; }

   if($wrn)
   { $warning ="<div class=warning_not_ok>Isilah Field di bawah dengan benar: <ul> $wrn </ul> </div>";
   }
   else
   {
     @cab=split(/\-/,$in{cabang});
     $kodecab = $cab[0];
     $nosurat = genfuncast::generate_nosuratop($in{dtop}, $dba1);

     #1. insert data atas ke OPNAMEH
     $query = $dba1->prepare("select max(recid) from opnameh  ");
     $query->execute();
     @row = $query->fetchrow_array();
     if($row[0]){ $recid=$row[0]+1; }
     else { $recid=1; }
#          print " INSERT INTO OPNAMEH (RECID, NOOPNAME, DTOPNAME, CABANG, OPRCREATE) VALUES
#        ($recid,'$nosurat','$in{dtop}','$kodecab','$s3s[0]');<br/> ";
     $q1 = $dba1->do("INSERT INTO OPNAMEH (RECID, NOOPNAME, DTOPNAME, CABANG, OPRCREATE) VALUES
        ($recid,'$nosurat','$in{dtop}','$kodecab','$s3s[0]');");

     if($q1!=0)
     {
       #2. insert opnamed
       $jml=0;
       for ($i=1; $i<=$in{baris}; $i++)
       { if($in{"kodeinv$i"})
         { $jml++;

           if ($in{"kry$i"})
           {
            @kry=split(/\-/,$in{"kry$i"});
            $nik = $kry[0];
            $query = $dba1->prepare("select idlama from getkry where nik='$nik'");
            $query->execute();
            @row = $query->fetchrow_array();
            $idlama=$row[0];
           }
           else { $idlama="0"; }

#     print "  INSERT INTO OPNAMED (OPNAMEID, KODEINV, CURRCABANG, CURRIDLAMA, KONDISI, KET, OPRCREATE, OLDIDLAMA, OLDKONDISI, OLDKET) VALUES
#                ($recid, '".$in{"kodeinv$i"}."', '$kodecab', '$idlama','".$in{"kondisi$i"}."','".$in{"ket$i"}."', '$s3s[0]',
#                 '".$in{"oldidlama$i"}."','".$in{"oldkondisi$i"}."','".$in{"oldket$i"}."');<br/> ";
           $q1 = $dba1->do("
                INSERT INTO OPNAMED (OPNAMEID, KODEINV, CURRCABANG, CURRIDLAMA, KONDISI, KET, OPRCREATE, OLDIDLAMA, OLDKONDISI, OLDKET) VALUES
                ($recid, '".$in{"kodeinv$i"}."', '$kodecab', '$idlama','".$in{"kondisi$i"}."','".$in{"ket$i"}."', '$s3s[0]',
                 '".$in{"oldidlama$i"}."','".$in{"oldkondisi$i"}."','".$in{"oldket$i"}."');");
           if($q1!=0){ $qsukses++; }
         }
       }
       if($qsukses==$jml){ $warning = "<div class=warning_ok>Sukses Simpan Opname </div>"; $sukses=1;  }
     }
     else { $warning = "<div class=warning_ok>Gagal Header Opname</div>"; }
     
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
~;
for ($i=1; $i<=20; $i++)
{ print qq~
   \$("#kry$i").catcomplete({
      delay: 0,
      source: data2
    });~;
}
print qq~
  });
  </script>
~;


print qq~
<div class="container">
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=200>
     <form method=post action="/cgi-bin/sisasset.cgi" >
      <input type="submit" name="back" value="BACK" class="huruf1"/>
      <input name="pages" type="hidden" value=at0014>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
     </td>
     <td align=center> <h2 class="hurufcol">Create Opname</h2> </td>
     <td align=right width=200>
     &nbsp;
     </td>
     </tr>
     </table>   $warning
~;

if($sukses==0)
{

print qq~

<script type='text/javascript' src='/jquery.min.js'></script>
<script type='text/javascript' src="/jquery.chained.js"></script>

<style type="text/css">\@import url("/jscalendar/calendar-blue.css");</style>
<script type="text/javascript" src="/jscalendar/calendar.js"></script>
<script type="text/javascript" src="/jscalendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="/jscalendar/calendar-setup.js"></script>

<form action="/cgi-bin/sisasset.cgi" method="post" name='add'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at0014c>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <table width='460px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp;Tanggal Opname </td>
    <td class="hurufcol" > <input name="dtop" type="text" id="dtop" size="12" maxlength="12" class="huruf1" value="$in{dtop}" />
        <img src="/jscalendar/img.gif" id="trigger1" style="cursor: pointer; border: 1px solid blue;"
                title="Date selector" onMouseOver="this.style.background='blue';" onMouseOut="this.style.background=''" />
        <script type="text/javascript">
        Calendar.setup(
        {
                inputField  : "dtop",         // ID of the input field
                ifFormat    : "%m/%d/%Y",    // the date format
                button      : "trigger1"       // ID of the button
	       //daFormat  :  "%Y/%m/%d"
        }
        );
        </script>
    </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp;Cabang </td>
    <td class="hurufcol" >
    <input type=text name=cabang id=cabang value="$in{cabang}" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase">
     </td>
    </tr>
</table>
 <input type=submit value='View' name="view" class="huruf1">
</form>~;

if($in{view})
{
print qq~
<form action="/cgi-bin/sisasset.cgi" method="post" name='add'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at0014c>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <input type=hidden name=dtop value=$in{dtop}>
  <input type=hidden name=cabang value=$in{cabang}>

  <table width='1300px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" width=30> No. </td>
   <td align='left' class="hurufcol" width=100> Jenis Inventori  </td>
   <td align='left' class="hurufcol" width=80> Kode Lama   </td>
   <td align='left' class="hurufcol" width=100> Kode Inventori  </td>
   <td align='left' class="hurufcol" width=100> Nama Inventori </td>
   <td align='left' class="hurufcol" width=60> Merek </td>
   <td align='left' class="hurufcol" width=60> Tipe </td>
   <td align='left' class="hurufcol" width=50> Ukuran </td>
   <td align='left' class="hurufcol" width=50> Warna </td>
   <td align='left' class="hurufcol" width=100> Pemilik </td>
   <td align='left' class="hurufcol" width=60> Kondisi </td>
   <td align='left' class="hurufcol" width=100> Keterangan </td>
  </tr>
~;

  @cab=split(/\-/,$in{cabang});
  $query = $dba1->prepare("select namaklp, kode, namajenis, merek, tipe , ukuran, warna, nik, nlengkap, kondisi, keterangan, idlama,kodelama
from inventori i, getkry k, jenisinv j, klpjenisinv ki
where i.curridlama=k.idlama and i.jenis=j.jenis and j.klpjenis=ki.klpjenis and  currcabang='$cab[0]'
order by nik, nlengkap, j.klpjenis, namajenis");
  $query->execute();
  $no=1;
  $tmpnik="";
  while (@row = $query->fetchrow_array())
  {  print qq~
    <tr bgcolor=$colcolor height=20>
     <td align='center' class="hurufcol" valign='top'>$no </td>
     <td align='left' class="hurufcol" valign='top'>$row[0]</td>
     <td align='left' class="hurufcol" valign='top'>$row[12]</td>
     <td align='left' class="hurufcol" valign='top'>$row[1]</td>
     <td align='left' class="hurufcol" valign='top'>$row[2]</td>
     <td align='left' class="hurufcol" valign='top'>$row[3]</td>
     <td align='left' class="hurufcol" valign='top'>$row[4]</td>
     <td align='left' class="hurufcol" valign='top'>$row[5]</td>
     <td align='left' class="hurufcol" valign='top'>$row[6]</td>
     <td align='center' class="hurufcol" valign='top'>
       <input type=text name=kry$no id=kry$no value="$row[7]-$row[8]" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase">
       <input type=hidden name=kodeinv$no value='$row[1]'>
       <input type=hidden name=oldidlama$no value='$row[11]'>
       <input type=hidden name=oldkondisi$no value='$row[9]'>
       <input type=hidden name=oldket$no value='$row[10]'></td>
     <td align='center' class="hurufcol" valign='top'>
       ~;
#for ($i=0; $i<@kondisi; $i++)
#{ $checked="";
#  if ($row[9] eq  $kondisi[$i]) { $checked="checked";}
#  print qq~<input type=radio name=kondisi$no value='$kondisi[$i]' class=huruf1 $checked> $kondisitext[$i] <br/>  ~;
#}

print qq~
<select name="kondisi$no" class="huruf1" id="kondisi$no">
     <option value=''>-</option> ~;
if ($cab[0] eq 'MISH_ALL')
{
for ($i=0; $i<@kondisi; $i++)
{ $selected="";
  if ($row[9] eq  $kondisi[$i]) { $selected="selected";}
  print qq~<option value='$kondisi[$i]' class=huruf1 $selected> $kondisitext[$i] </option> ~;
}
 }
else {
for ($j=0; $j<@kondisi1; $j++)
{ $selected="";
  if ($row[9] eq  $kondisi1[$j]) { $selected="selected";}
  print qq~<option value='$kondisi1[$j]' class=huruf1 $selected> $kondisitext1[$j] </option> ~;
}
}
print qq~ </select> ~;




#print qq~
# <select name="kondisi$no" class="huruf1" id="kondisi$no">
#        <option value=''>-</option> ~;
#$selected="";
#if ($cab[0] eq 'MIS_ALL')
#{       print qq~ <option value='L' $selected>Layak</option>
#                 <option value='R' $selected>Rusak</option>
#                 <option value='W' $selected>Waste</option> ~;
#} else {
#       print qq~ <option value='L' $selected>Layak</option>
#                 <option value='R' $selected>Rusak</option>~;

#}
#print qq~
#</select>~;


print qq~</td>
     <td align='center' class="hurufcol" valign='top'>
       <input type=text name=ket$no id=ket$no value="$row[10]" class=huruf1 size=35 maxlength="30"></td>
    </tr>
     ~;
    $no++;
  }
  
  $no--;
  print qq~ </table>
  <input type=hidden name=baris value=$no>
  <input type=submit name=simpan value=Simpan>
  </form>
   ~;
}

}#end if $sukses=0

print qq~
    <hr width="100" />
</center>~;
}


1

