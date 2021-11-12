sub at0021 {

genfuncast::view_header($in{ss}, $s3s[2], 'Hapus Inventori');
genfuncast::validasi_akses($s3s[11], $in{ss});
&koneksi_ast2;

@kondisi = ('B','L');
@kondisitext = ('Baru','Layak');

@flag = ('Y');
@flagtext = ('Yes');

if ($in{action} eq 'hapus')
{  $q = $dba1->prepare("select count(*) from kirimd d where d.kodeinv='$in{itemhapus}' and batal='N'");
   $q->execute();
   @rec = $q->fetchrow_array();
   $sudahdikirim=$rec[0];

   if($sudahdikirim>0)
   { $warning = "<div class='warning_not_ok'>Inventori sudah tidak di Gudang MIS<br/> ";
   }
   else
   {   $q1 = $dba1->do("delete from inventori where kode='$in{itemhapus}';");

       if($q1!=0){  $warning = "<div class='warning_ok'>Sukses Hapus Inventori </div><br/> "; }
       else { $warning = "<div class='warning_not_ok'>Gagal Hapus Inventori (1=$q1)</div><br/> "; }
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
$query = $dba1->prepare("select kodecabang,namacabang, kodebu from getstruk where (kodecabang like 'C%' or sisasset='Y') order by kodecabang");
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
    var data3 = [
~;
$str="";
$query = $dba1->prepare("select kode, merek, warna, namajenis, currcabang, curridlama, kondisi, kodeasset, noseri, kodelama
from inventori i, jenisinv j where i.jenis=j.jenis and (currcabang like 'MW%') order by kode ");
$query->execute();
while (@rec = $query->fetchrow_array())
{  $str.= qq~ { label: "$rec[0]-$rec[9]-$rec[1]-$rec[2]-$rec[4]-$rec[5]-$rec[6]-$rec[7]-$rec[8]", category: "$rec[3]" },~ ;
}
$n = length($str) - 1;
$str = substr $str,0,$n;

print qq~
      $str
    ];

    \$("#item1").catcomplete({
      delay: 0,
      source: data3
    });
  });
  </script>
~;

print qq~
<div class="container">
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=200>
     &nbsp;
     </td>
     <td align=center> <h2 class="hurufcol">Hapus Inventori</h2> </td>
     <td align=right width=200>
     &nbsp;
     </td>
     </tr>
     </table>
~;


print qq~
$warning

<script type="text/javascript">
function toHapus()
{  var result = confirm("Yakin Hapus Inventori ? ");
        if (result==true) {
         with(document.hapus)
          { action.value='hapus';
            submit();
          }
         }
}
</script>

<form action="/cgi-bin/sisasset.cgi" method="post" name='add'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value='at0021'>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
<table width='600px' border='0' cellspacing='2' cellpadding='2'>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120 valign=top>&nbsp;Kode Inventori </td>
    <td class='hurufcol' width=200>
    <input type=text name='item1' id='item1' value='$in{item1}' class=huruf1 size=60 maxlength=50 style='text-transform: uppercase'>
    </td>
    </tr>
</table>
 <input type=submit value='Cek' name="cek" class="huruf1">
</form>
~;

if($in{cek})
{
  @kd = split('\-', $in{item1});
  $query = $dba1->prepare("select i.kode,j.namajenis,m.namamerek,w.namawarna,t.namatipe,u.namaukuran,case when i.flagasset='N' then 'No' else  'Yes' end Flagasset,
case when i.kondisi='L' then 'Layak' when i.kondisi='B' then 'Baru' else 'Rusak' end Kondisi,i.noseri,i.ip,s.namacabang,
k.nlengkap, k.nik, i.oprcreate, i.kodelama, i.os, i.computername, i.keterangan, i.dtbeli, i.harga, i.kodeasset,
i.groupkode, i.currcabang
from inventori i
left outer join jenisinv j on i.jenis=j.jenis
left outer join merek m on i.merek=m.merek
left outer join tipeinv t on i.tipe=t.tipe
left outer join ukuraninv u on i.ukuran=u.ukuran
left outer join warna w on i.warna=w.warna
left outer join getstruk s on s.kodecabang=i.currcabang
left outer join getkry k on k.idlama=i.curridlama
where i.kode='$kd[0]' order by j.jenis, i.dtcreate desc ");
  $query->execute();
  @record = $query->fetchrow_array();

  $ketgrup="";
  if($record[21]){ $ketgrup=" (Group : $record[21])"; }

  $kda="";
  if($record[6] eq 'Yes'){ $kda = "&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Kode Asset : $record[20] "; }
  print qq~
<form action="/cgi-bin/sisasset.cgi" method="post" name='hapus'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at0021>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <input type=hidden name=itemhapus value='$kd[0]'>
  <input type=hidden name=action value=''>

<table width='680px' border='0' cellspacing='1' cellpadding='2'>
<tr bgcolor=$colcolor height=20>
    <td class="hurufcol">&nbsp;Kode Inventori </td>
    <td class="hurufcol" bgcolor=$colcolor2 > $kd[0] &nbsp;&nbsp; &nbsp;&nbsp; $ketgrup
    </td>
</tr>
<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Jenis Inventori </td>
    <td class="hurufcol" bgcolor=$colcolor2> $record[1]

&nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; Flag Asset :
 $record[6]  $kda
    </td>
</tr>

<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Merek </td>
    <td class="hurufcol" bgcolor=$colcolor2> $record[2]    </td>
</tr>

<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Model / Tipe </td>
    <td class="hurufcol" bgcolor=$colcolor2> $record[4]    </td>
</tr>

<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Ukuran </td>
    <td class="hurufcol" bgcolor=$colcolor2> $record[5]    </td>
</tr>

<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Warna </td>
    <td class="hurufcol" bgcolor=$colcolor2> $record[3]    </td>
</tr>

<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Nomor Seri </td>
    <td class="hurufcol" bgcolor=$colcolor2> $record[8]
    &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp; Kode Lama
    : $record[14]    </td>
</tr>

<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Kondisi </td>
<td class="hurufcol" bgcolor=$colcolor2>$record[7]</td>
</tr>

<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Keterangan </td>
    <td class="hurufcol" bgcolor=$colcolor2> $record[17]    </td>
</tr>

<tr bgcolor=$colcolor height=20>
   <td class="hurufcol">&nbsp;Tanggal Beli</td>
   <td class="hurufcol" bgcolor=$colcolor2> $record[18]    </td>
</tr>

<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Harga </td>
    <td class="hurufcol" bgcolor=$colcolor2> $record[19]    </td>
  </tr>

<tr bgcolor=$colcolor height=20>
    <td class="hurufcol">&nbsp;Nama Karyawan </td>
    <td class="hurufcol" bgcolor=$colcolor2> $record[12] - $record[11]
     &nbsp; &nbsp;/ Cabang Store : $record[10]
     </td>
</tr>

<tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=120>&nbsp;Computer Name</td>
    <td class="hurufcol" bgcolor=$colcolor2>$record[16]
     &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; IP :
    $record[9]
    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; OS :
   $record[15]
    </td>
</tr>
</table>
  ~;
  
  if(($record[22] eq 'MWBIG' or $record[22] eq 'MWSMALL') )
  { print qq~<input type="button" name="hapus" value="Hapus" class="huruf1" onClick="toHapus();"/>~;
  }
  print qq~</form>~;
}

print qq~
    <hr width="100" />
</center>~;
}


1

