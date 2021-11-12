sub at0014e {

genfuncast::view_header($in{ss}, $s3s[2], 'Edit Opname');
genfuncast::validasi_akses($s3s[11], $in{ss}, 'S');
&koneksi_ast2;

@kondisi = ('L','R','W');
@kondisitext = ('Layak','Rusak','Waste');

@kondisi1 = ('L','R');
@kondisitext1 = ('Layak','Rusak');

@flag = ('A','T');
@flagtext = ('Asset','Attribut');

if ($in{simpan})
{  $sukses=0;
   if(!$in{dtop}) { $wrn = "<li>Tgl Opname harus diisi</li>"; }

   if($wrn)
   { $warning ="<div class=warning_not_ok>Isilah Field di bawah dengan benar: <ul> $wrn </ul> </div>";
   }
   else
   {
     #1. update OPNAMEH
    # print " update OPNAMEH set dtopname='$in{dtop}', oprupdate='$s3s[0]' where recid='$in{recido}';<br/> ";
     $q1 = $dba1->do(" update OPNAMEH set dtopname='$in{dtop}', oprupdate='$s3s[0]' where recid='$in{recido}';");

     if($q1!=0)
     {
       #2. update opnamed
       $jml=0;
       for ($i=1; $i<=$in{baris}; $i++)
       { if($in{"recid$i"})
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

        #   print "  update OPNAMED set curridlama='$idlama', kondisi='".$in{"kondisi$i"}."', ket='".$in{"ket$i"}."', oprupdate='$s3s[0]'
        #     where recid='".$in{"recid$i"}."';<br/> ";
           $q1 = $dba1->do("update OPNAMED set curridlama='$idlama', kondisi='".$in{"kondisi$i"}."', ket='".$in{"ket$i"}."', oprupdate='$s3s[0]'
             where recid='".$in{"recid$i"}."';");
           if($q1!=0){ $qsukses++; }
         }
       }
       if($qsukses==$jml){ $warning = "<div class=warning_ok>Sukses Simpan Opname </div>"; $sukses=1;  }
     }
     else { $warning = "<div class=warning_not_ok>Gagal Header Opname</div>"; }
     
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
     <td align=center> <h2 class="hurufcol">Edit Opname</h2> </td>
     <td align=right width=200>
     &nbsp;
     </td>
     </tr>
     </table>   $warning
~;

if($in{recido})
{

$query = $dba1->prepare("select NOOPNAME, DTOPNAME, CABANG, namacabang, CABAPP, CABOPR, DTCAB, AUDAPP, AUDOPR, DTAUD, OPRCREATE
        from opnameh h, getstruk c where h.cabang=c.kodecabang and recid=$in{recido}");
$query->execute();
@record = $query->fetchrow_array();
print qq~

<script type='text/javascript' src='/jquery.min.js'></script>
<script type='text/javascript' src="/jquery.chained.js"></script>

<style type="text/css">\@import url("/jscalendar/calendar-blue.css");</style>
<script type="text/javascript" src="/jscalendar/calendar.js"></script>
<script type="text/javascript" src="/jscalendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="/jscalendar/calendar-setup.js"></script>

<form action="/cgi-bin/sisasset.cgi" method="post" name='add'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at0014e>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <input type=hidden name=recido value="$in{recido}">
  
  <table width='450px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp;No. Opname </td>
    <td class="hurufcol" bgcolor=$colcolor2 > $record[0]    </td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp;Tanggal Opname </td>
    <td class="hurufcol" bgcolor=$colcolor2> <input name="dtop" type="text" id="dtop" size="12" maxlength="12" class="huruf1" value="$record[1]" />
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
    <td class="hurufcol" bgcolor=$colcolor2>  $record[2]-$record[3]   </td>
    </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp;Auditor </td>
    <td class="hurufcol" bgcolor=$colcolor2>  $record[10]   </td>
    </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp;Approval Head Cabang </td>
    <td class="hurufcol" bgcolor=$colcolor2>  $record[4] ($record[5]) <br/> $record[6]   </td>
    </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp;Approval Head Audit </td>
    <td class="hurufcol" bgcolor=$colcolor2>   $record[7] ($record[8]) <br/> $record[9]   </td>
    </tr>
</table> <br/> <br/>
~;

print qq~
  <table width='1300px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" width=30> No. </td>
   <td align='left' class="hurufcol" width=100> Jenis Inventori  </td>
   <td align='left' class="hurufcol" width=100> Kode Lama  </td>
   <td align='left' class="hurufcol" width=100> Kode Inventori   </td>
   <td align='left' class="hurufcol" width=100> Nama Inventori </td>
   <td align='left' class="hurufcol" width=40> Merek </td>
   <td align='left' class="hurufcol" width=40> Tipe </td>
   <td align='left' class="hurufcol" width=50> Ukuran </td>
   <td align='left' class="hurufcol" width=50> Warna </td>
   <td align='left' class="hurufcol" width=100> Pemilik </td>
   <td align='left' class="hurufcol" width=60> Kondisi </td>
   <td align='left' class="hurufcol" width=100> Keterangan </td>
  </tr>
~;

  $query = $dba1->prepare("select  namaklp, kode, namajenis, merek, tipe , ukuran, warna, nik, nlengkap, d.kondisi, d.ket, idlama,
  oldidlama, oldkondisi, oldket, d.recid,kodelama
 from opnamed d, getkry k, inventori i, jenisinv j, klpjenisinv ki
 where  d.curridlama=k.idlama  and d.kodeinv=i.kode and i.jenis=j.jenis
 and j.klpjenis=ki.klpjenis  and opnameid=$in{recido}
 order by nik, namaklp");
  $query->execute();
  $no=1;
  $tmpnik="";
  while (@row = $query->fetchrow_array())
  {  $oldpemilik=""; $oldkondisi=""; $oldket="";
     if($row[9] != $row[13]){ $oldkondisi="Dulu : <b>$row[13]</b>"; }
     if($row[10] != $row[14]){ $oldket="Dulu : <b>$row[14]</b>"; }
     if($row[11] != $row[12])
     { $q = $dba2->prepare("select  nik, nlengkap from getkry where idlama='$row[12]'");
       $q->execute();
       @row2 = $q->fetchrow_array();
        $oldpemilik="Dulu : <b>$row2[0] - $row2[1]</b>";
     }
     
     print qq~
    <tr bgcolor=$colcolor height=20>
     <td align='center' class="hurufcol" valign='top'>$no </td>
     <td align='left' class="hurufcol" valign='top'>$row[0]</td>
     <td align='left' class="hurufcol" valign='top'>$row[16]</td>
     <td align='left' class="hurufcol" valign='top'>$row[1]</td>
     <td align='left' class="hurufcol" valign='top'>$row[2]</td>
     <td align='left' class="hurufcol" valign='top'>$row[3]</td>
     <td align='left' class="hurufcol" valign='top'>$row[4]</td>
     <td align='left' class="hurufcol" valign='top'>$row[5]</td>
     <td align='left' class="hurufcol" valign='top'>$row[6]</td>
     <td align='left' class="hurufcol" valign='top'>
       <input type=text name=kry$no id=kry$no value="$row[7]-$row[8]" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase">
       <input type=hidden name=recid$no value='$row[15]'>  <br/> $oldpemilik
     <td align='center' class="hurufcol" valign='top'>
       ~;
#for ($i=0; $i<@kondisi; $i++)
#{ $checked="";
#  if ($row[9] eq  $kondisi[$i]) { $checked="checked";}
#  print qq~<input type=radio name=kondisi$no value='$kondisi[$i]' class=huruf1 $checked> $kondisi[$i] <br/> $oldkondisi ~;
#}

print qq~
<select name="kondisi$no" class="huruf1" id="kondisi$no">
     <option value=''>-</option> ~;
if ($record[2] eq 'MISH_ALL')
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
#if
#if ($record[2] eq 'MIS_ALL')
#{
#      print qq~  <option value='L' $selected>Layak</option>
#                 <option value='R' $selected>Rusak</option>
#                 <option value='W' $selected>Waste</option>~;
#} else {
#       print qq~ <option value='L' $selected>Layak</option>
#                 <option value='R' $selected>Rusak</option>~;

#}
#print qq~
#</select>~;


       print qq~</td>
     <td align='left' class="hurufcol" valign='top'>
       <input type=text name=ket$no id=ket$no value="$row[10]" class=huruf1 size=35 maxlength="30"> <br/>
       $oldket</td>
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

}#end if $sukses=0

print qq~
    <hr width="100" />
</center>~;
}


1

