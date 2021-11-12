sub kop004c {

genfunckop::validasi_akses_kop($s3s[11], $in{ss});

print qq~
<script type='text/javascript' src='/jquery.min.js'></script>
<script type='text/javascript' src="/jquery.chained.js"></script>
<style type="text/css">
\@import url("/jscalendar/calendar-blue.css");
</style>

<script type="text/javascript" src="/jscalendar/calendar.js"></script>
<script type="text/javascript" src="/jscalendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="/jscalendar/calendar-setup.js"></script>
      <br/> &nbsp;   <br/>
     <table width=100% border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=150>
     &nbsp;
     </td>
     <td align=center> <h2 class="hurufcol"> TAMBAH ANGGOTA</h2> </td>
     <td align=left width=150>&nbsp; </td>
     </tr>
     </table>
     <br/>
~;

($month,$day,$year,$weekday) = &jdate(&today());

if($in{simpan})
{
   $in{pokok}=~ s/\'/\ /g;
   $in{pokok}=~ s/\"/\ /g;
   $in{sukarela}=~ s/\'/\ /g;
   $in{sukarela}=~ s/\"/\ /g;

   $wrn='';
   if (!($in{nikgo})) { $wrn.="<li>Karyawan</li>"; }
   if (!($in{dtjoin})) { $wrn.="<li>Tgl Join</li>"; }
   if (!($in{pokok})) { $wrn.="<li>Simpanan Pokok</li>"; }
   if (!($in{sukarela})) { $wrn.="<li>Simpanan Sukarela</li>"; }

   if ($wrn ne "" )
   {  $warning = "<div class='warning_not_ok'>Isilah field-field di bawah dengan format yang benar: $wrn</div><br/>";
   }
   else
   {
     $in{nikgo} = substr $in{nikgo},0,9;
     $in{nikgo} = uc $in{nikgo} ;
     $query = $dbp->prepare("select idlama from stafbiodata where nik='$in{nikgo}' ");
     $query->execute();
     @rec = $query->fetchrow_array();
     $idlama = $rec[0];

     if($idlama)
     {
      $query = $dbk->prepare("select count(*) from anggota where idlama='$idlama' ");
      $query->execute();
      @rec = $query->fetchrow_array();
      $jmldaftar=$rec[0];
      
      $query = $dbk->prepare("select extract(year from dtkeluar),
        datediff(month, dtkeluar, current_date),  dtkeluar from anggota where idlama='$idlama' and dtkeluar is not null
        order by dtkeluar desc");
      $query->execute();
      @rec = $query->fetchrow_array();
      $flaglama=0;
      if($rec[0]){ $flaglama=1; }
     }
     print qq~lama = $flaglama~;
     
     if(!$idlama)
     { print qq~<div class=warning_not_ok>NIK '$in{nikgo}' tidak valid </div>~;
     }
     elsif($jmldaftar>=3)
     { print qq~<div class=warning_not_ok>NIK '$in{nikgo}' sudah mendaftar >= 3x  </div>~;
     }
     elsif($flaglama==1 and ($rec[0]==$year or $rec[1]<=6))
     { $dtkeluar = genfuncpyl::mdytodmy($rec[2]);
       print qq~<div class=warning_not_ok>NIK '$in{nikgo}' baru keluar dari anggota koperasi per tgl '$dtkeluar' <br/>
       (Belum 6 bulan dari tgl keluar dan masih di tahun yang sama dengan tahun keluar anggota) </div>~;
     }
     else
     {
      #print qq~select idlama from stafbiodata where nik='$in{nikgo}' ->> $idlama ~;
      $pridjoin = genfunckop::getPeriodeKop($in{dtjoin});

#      print qq~INSERT INTO ANGGOTA (IDLAMA, DTJOIN, PERIODJOIN,  OPRCREATE) VALUES
#                ('$idlama','$in{dtjoin}','$pridjoin','$s3s[0]');<br/>
#            INSERT INTO SIMPANAN (IDLAMA, JENIS, JUMLAH, DTBERLAKU, DTEXPIRED, OPRCREATE) VALUES
#         ('$idlama','P','$in{pokok}','$in{dtjoin}','1/1/2099','$s3s[0]');<br/>
#           INSERT INTO SIMPANAN (IDLAMA, JENIS, JUMLAH, DTBERLAKU, DTEXPIRED, OPRCREATE) VALUES
#         ('$idlama','S','$in{sukarela}','$in{dtjoin}','1/1/2099','$s3s[0]'); <br/>
#          ~;
      $q1 = $dbk->do("INSERT INTO ANGGOTA (IDLAMA, DTJOIN, PERIODJOIN,  OPRCREATE) VALUES
                ('$idlama','$in{dtjoin}','$pridjoin','$s3s[0]');");
      $q2 = $dbk->do("INSERT INTO SIMPANAN (IDLAMA, JENIS, JUMLAH, DTBERLAKU, DTEXPIRED, OPRCREATE) VALUES
         ('$idlama','P','$in{pokok}','$in{dtjoin}','1/1/2099','$s3s[0]'); ");
      $q3 = $dbk->do("INSERT INTO SIMPANAN (IDLAMA, JENIS, JUMLAH, DTBERLAKU, DTEXPIRED, OPRCREATE) VALUES
         ('$idlama','S','$in{sukarela}','$in{dtjoin}','1/1/2099','$s3s[0]');");
#      $q4 = $dbk->do("INSERT INTO IURAN (PERIODE, IDLAMA, JENIS, HRSBAYAR, JMLBAYAR, DTBAYAR, OPRCREATE) VALUES
#        ('$pridjoin','$rec[0]', 'P','$in{pokok}','$in{pokok}','$in{dtjoin}','$s3s[0]' );  ");
#      $q5 = $dbk->do("INSERT INTO IURAN (PERIODE, IDLAMA, JENIS, HRSBAYAR, JMLBAYAR, DTBAYAR, OPRCREATE) VALUES
#        ('$pridjoin','$rec[0]', 'S','$in{sukarela}','$in{sukarela}','$in{dtjoin}','$s3s[0]' );");
      if($q1!=0 && $q2!=0 && $q3!=0 )    #&& $q4!=0 && $q5!=0
      { print qq~<div class=warning_ok> Sukses Tambah Anggota </div> ~;
      }
      else
      { print qq~<div class=warning_not_ok> Tidak Berhasil Tambah Anggota : 1=$q1 2=$q2 3=$q3  </div> ~; #4=$q4 5=$q5
      }
     }
   }
}
else
{
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
select nik, nlengkap, kodecabang
from getkry where aktif='Y' and idlama not in (select idlama from anggota where aktif='Y')");
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
print qq~<form action="/cgi-bin/kopbox.cgi" method="post" name='vq'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=display value=kop004c>
<table>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp; Karyawan </td>
    <td class="hurufcol"> <input type=text name=nikgo id=nikgo value="$in{nikgo}" class=huruf1 size=40 maxlength="50" style="text-transform: uppercase"></td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp; Simpanan Pokok </td>
    <td class="hurufcol"> <input type=hidden name=pokok id=pokok value="50000"> <input type=text disabled name=pkk value=50000 size=10 style="text-align: right"></td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp; Simpanan Sukarela </td>
    <td class="hurufcol"> <input type=text name=sukarela id=sukarela value="$in{sukarela}" class=huruf1 size=10 maxlength="7" style="text-align: right"></td>
  </tr>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"> &nbsp; Tgl Join </td>
    <td class="hurufcol" ><input class='huruf1' name="dtjoin" type="text" id="dtjoin" size="12" maxlength="12" value="$in{dtjoin}"   onChange="hitungDurasi()"/>
       <img src="/jscalendar/img.gif" id="trigger3" style="cursor: pointer; border: 1px solid blue;" title="Date selector" onMouseOver="this.style.background='blue';" onMouseOut="this.style.background=''" />
       <script type="text/javascript">
       Calendar.setup(
       {
        inputField  : "dtjoin",         // ID of the input field
        ifFormat    : "%m/%d/%Y",    // the date format
        button      : "trigger3"       // ID of the button
	  //daFormat  :  "%Y/%m/%d"
        }
       );
       </script>
    </td>
    </tr>
   <tr>
    <td colspan=2 align=center><input type='submit' name='simpan' value='Simpan'> </td>
  </tr>
</table>
</form>    ~;
}

print qq ~
    <hr width="100" />
</center>
~;
}

;
1

