sub kop022 {

genfunckop::view_header_kop($in{ss}, $s3s[2], 'Pencairan Simpanan', $s3s[17]);
genfunckop::validasi_akses_kop($s3s[11], $in{ss});
&koneksi_kop2;

print qq~
<style type="text/css">
\@import url("/jscalendar/calendar-blue.css");
   .hoverTable tr{
		background: #ffffff;
	}
    .hoverTable tr:hover {
          background-color: #ffff99;
    }
    .hoverTable td:hover {
          border: 2px solid red;
    }
</style>
<script type="text/javascript" src="/jscalendar/calendar.js"></script>
<script type="text/javascript" src="/jscalendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="/jscalendar/calendar-setup.js"></script>

<script type='text/javascript' src='/jquery.min.js'></script>
<script type='text/javascript' src="/jquery.chained.js"></script>
<link rel="stylesheet" href="/colorbox.css" />
<script type="text/javascript" src="/jquery.colorbox.js"></script>

<script type="text/javascript">
\$(document).ready(function(){
   \$(".iframe").colorbox({
      iframe:true,
      width:"950px",
      height:"95%"});

    \$("#click").click(function(){
	 \$(".iframe").colorbox.close();
    });
});
</script>

     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=right width=50>&nbsp;
      </td>
     <td align=center> <h2 class="hurufcol">PENCAIRAN SIMPANAN </h2> </td>
      <td align=right width=50>~;
if($s3s[11] eq 'S')
{ print qq~<form method=post action="/cgi-bin/siskop.cgi" >
      <input type="submit" name="back" value="Tambah Pencairan" class="huruf1"/>
      <input name="pages" type="hidden" value=kop022c>
      <input name="ss" type="hidden" value="$in{ss}"> </form>~;
}
print qq~
      </td>
     </tr>
     </table>
~;

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
where a.idlama=k.idlama and a.aktif!='Z' and a.idlama not in (select idlama from pinjaman where lunas='N')  order by nlengkap ");
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

@simp = ('S', 'P');
@simp_text = ('Sukarela','Pokok');
print qq~
<form action="/cgi-bin/siskop.cgi" method="post" name='vq'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=kop022>
<table>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp; Tgl Pencairan </td>
    <td class="hurufcol" ><input class='huruf1' name="dtcair" type="text" id="dtcair" size="12" maxlength="12" value="$in{dtcair}" />
       <img src="/jscalendar/img.gif" id="trigger3" style="cursor: pointer; border: 1px solid blue;" title="Date selector" onMouseOver="this.style.background='blue';" onMouseOut="this.style.background=''" />
       <script type="text/javascript">
       Calendar.setup(
       {
        inputField  : "dtcair",         // ID of the input field
        ifFormat    : "%m/%d/%Y",    // the date format
        button      : "trigger3"       // ID of the button
	  //daFormat  :  "%Y/%m/%d"
        }
       );
       </script> s/d <input class='huruf1' name="dtcair2" type="text" id="dtcair2" size="12" maxlength="12" value="$in{dtcair2}" />
       <img src="/jscalendar/img.gif" id="trigger4" style="cursor: pointer; border: 1px solid blue;" title="Date selector" onMouseOver="this.style.background='blue';" onMouseOut="this.style.background=''" />
       <script type="text/javascript">
       Calendar.setup(
       {
        inputField  : "dtcair2",         // ID of the input field
        ifFormat    : "%m/%d/%Y",    // the date format
        button      : "trigger4"       // ID of the button
	  //daFormat  :  "%Y/%m/%d"
        }
       );
       </script>
    </td>
    </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150 valign=top> &nbsp; Jenis Simpanan </td>
    <td class="hurufcol"> <select name=simpanan>
     <option value=''>ALL</option> ~;
    for ($i=0; $i<@simp; $i++)
    { $j=$i+1;
      $selected="";
      if($in{"simpanan"} eq $simp[$i]){ $selected='selected';}
      print qq~<option value='$simp[$i]' $selected> $simp_text[$i] </option> ~;
    }
    print qq~ </select></td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp; Karyawan </td>
    <td class="hurufcol"> <input type=text name=nikgo id=nikgo value="$in{nikgo}" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase"></td>
  </tr>
</table><input type='submit' name='search' value='Search'>
</form>
~;

if($in{reciddel})
{
     $query = $dbk->prepare("select kategori, idlama from PENCAIRAN where recid='$in{reciddel}' ");
     $query->execute();
     @rec = $query->fetchrow_array();

     $q1 = $dbk->do("update iuran set PENCAIRANid=null, oprupdate='$s3s[0]' where PENCAIRANid='$in{reciddel}'; ");
     $q2 = $dbk->do("update PENCAIRAN set batal='Y', oprupdate='$s3s[0]' where recid = '$in{reciddel}';");

     if($q1!=0 && $q2!=0)
     { print qq~<div class=warning_ok>Sukses Batalkan Pencairan Simpanan </div>~;
       if($rec[0] eq 'PSP')
       { $qd = $dbk->do("update anggota set aktif='Y', oprupdate='$s3s[0]' where idlama = '$rec[1]'");
         print qq~<div class=warning_ok>Sukses Aktifkan Anggota Kembali</div>~;
       }
     }
     else { print qq~<div class=warning_ok>Gagal Batalkan Pencairan Simpanan 1=$q1 2=$q2 </div>~; }
}

if($in{search})
{    $subq="";
     if($in{nikgo})
     {
       $in{nikgo} = substr $in{nikgo},0,9;
       $in{nikgo} = uc $in{nikgo} ;
       $subq.=" and nik='$in{nikgo}' ";
     }
     if($in{simpanan}) {  $subq.=" and kategori like 'PS".$in{simpanan}."%' "; }
     if($in{dtcair}) {  $subq.=" and dttransaksi>='$in{dtcair}' "; }
     if($in{dtcair2}) {  $subq.=" and dttransaksi<='$in{dtcair2}' "; }

     print qq~
<script type="text/javascript">
function toDelete(n)
{  var result = confirm("Yakin Batalkan Pencairan Simpanan?");
        if (result==true)
        { with(document.ps)
          {  reciddel.value = n;
             submit();
          }
        }
}
</script>

<form action="/cgi-bin/siskop.cgi" method="post" name="ps">
  <input type=hidden name=ss value="$in{ss}">
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <input type=hidden name=pages value='kop022'>
  <input type=hidden name=reciddel value=''>

     <table border=0 cellspacing=0 cellpadding=2 width=1000>
        <tr bgcolor=$dark height=20 class=hurufcol>
          <td align=center width=30><b>No</b></td>
          <td align=center width=80><b>Tgl Pencairan</b></td>
          <td align=center width=100><b>Cabang</b></td>
          <td align=center width=60><b>NIK</b></td>
          <td align=center width=120><b>Nama Karyawan</b></td>
          <td align=center width=30><b>Kategori</b></td>
          <td align=center width=80><b>Jumlah</b></td>
          <td align=center width=100><b>Keterangan</b></td>
          <td align=center width=30><b>Batal</b></td>
        </tr> ~;
        
     $query = $dbk->prepare("select dttransaksi, kodecabang, namastore, nik, nlengkap, kategori, jumlah, keterangan, batal, recid, m.idlama
     from PENCAIRAN m, getkry k where m.idlama=k.idlama and batal='N' $subq order by dttransaksi, nik, keterangan ");
     $query->execute(); $no=1;   $total=0;
     while (@rec = $query->fetchrow_array())
     { $dt = genfuncpyl::mdytodmy($rec[0]);
       $jml = genfuncpyl::ribuan($rec[6]);
       if($rec[8] eq 'N'){ $total+=$rec[6]; }
       
       if($rec[8] eq 'N' and $s3s[11] eq 'S')
       { $btn = "<input type='image' src='/images/del.png' name='del$no' value='Delete' class='huruf1' onClick=\"toDelete('$rec[9]');\">";
       }
       else { $btn = $rec[8]; }
       
       if($no%2==1){ $bg=$colcolor; }
       else { $bg=$colcolor2; }

       if($rec[8] eq 'N'){ $link = "<a class='iframe' href='/cgi-bin/kopbox.cgi?display=kop022d&idlama=$rec[10]&dt=$rec[0]&ss=$in{ss}'>$dt</a>"; }
       else { $link=$dt; $bg="dddddd";  }

       print qq~
       <tr bgcolor=$bg class=hurufcol>
          <td align=center>$no</td>
          <td align=center>$link</td>
          <td align=center>$rec[1]-$rec[2]</td>
          <td align=center>$rec[3]</td>
          <td>$rec[4]</td>
          <td align=center>$rec[5]</td>
          <td align=right>$jml</td>
          <td>$rec[7]</td>
          <td align=center>$btn</td>
       </tr>   ~;
       $no++;
     }
     
     $txttotal = genfuncpyl::ribuan($total);
     print qq~<tr bgcolor=$dark class=hurufcol height=20>
          <td align=center colspan=6><b> TOTAL </b> </td>
          <td align=right><b>$txttotal</b></td>
          <td>&nbsp; </td>
          <td align=center>&nbsp; </td>
       </tr>
     </table>
     <div class=hurufcol>Note : Pembatalan PSP otomatis mengaktifkan kembali Anggota </div>
      </form> ~;
}

print qq ~
    <hr width="100" />
</center>
~;
}

;
1

