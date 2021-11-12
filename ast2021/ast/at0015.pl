sub at0015 {

&koneksi_ast2;

genfuncast::view_header($in{ss}, $s3s[2], 'Approval Opname Cabang');
genfuncast::validasi_akses($s3s[11], $in{ss});

#if ($s3s[0] eq 'XTIN') {$s3s[4]='MIS_ALL'}

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

     <td align=center> <h2 class="hurufcol"> APPROVAL CABANG</h2> </td>
     ~;
  print qq~
     </tr>
     </table>

<form action="/cgi-bin/sisasset.cgi" method="post" name='vq'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at0015>
<table>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol" width=150> &nbsp;Tanggal Opname  </td>
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
        </script> s/d <input name="dtop2" type="text" id="dtop2" size="12" maxlength="12" class="huruf1" value="$in{dtop2}" />
        <img src="/jscalendar/img.gif" id="trigger2" style="cursor: pointer; border: 1px solid blue;"
                title="Date selector" onMouseOver="this.style.background='blue';" onMouseOut="this.style.background=''" />
        <script type="text/javascript">
        Calendar.setup(
        {
                inputField  : "dtop2",         // ID of the input field
                ifFormat    : "%m/%d/%Y",    // the date format
                button      : "trigger2"       // ID of the button
	       //daFormat  :  "%Y/%m/%d"
        }
        );
        </script>
    </td>

    <tr>
    <td align=center colspan=2><input type='submit' name='search' value='Search'> </td>
  </tr>
  </table>
</form> <br/>
~;

if ($in{search})
{
print qq ~
<script type="text/javascript">
function toedit(n)
{  with(document.st)
   { pages.value='at0015a';
     recido.value=n;
     submit();
   }
}
</script>
 $warning_del
<FORM ACTION="/cgi-bin/sisasset.cgi" METHOD="post" name='st'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value=at0015a>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <input type=hidden name=recido value=>
 ~;
}
print qq~
<script type='text/javascript' src='/jquery.min.js'></script>
  <table width='1000px' border='0' cellspacing='1' cellpadding='2'>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol" width=30> No. </td>
   <td align='left' class="hurufcol" width=100> No. Opname  </td>
   <td align='left' class="hurufcol" width=100> Tanggal Opname   </td>
   <td align='left' class="hurufcol" width=100> Cabang </td>
   <td align='left' class="hurufcol" width=100> Jumlah Inventori </td>
   <td align='left' class="hurufcol" width=100> Created By </td>
   <td align='left' class="hurufcol" width=100> Approval Head Cabang </td>
   </tr>
~;

$subq="";
if ($in{dtop})
{  $subq.=" and dtopname>='$in{dtop}'";
   if ($in{dtop2}) {$subq.=" and dtopname<='$in{dtop2}'"; }
   else  {$subq.=" and dtopname<='$in{dtop}'"; }
}

$q = $dba1->prepare("select noopname, dtopname, cabang, count(d.recid), cabapp, cabopr, dtcab, audapp, audopr, dtaud, h.recid,h.oprcreate
from opnameh h, opnamed d
where h.recid=d.opnameid   and cabang='$s3s[4]'
group by noopname, dtopname, cabang, cabapp, cabopr, dtcab, audapp, audopr, dtaud, h.recid,h.oprcreate
order by noopname ");
$q->execute();
$no=1;
while (@row = $q->fetchrow_array())
{
  if ($s3s[11] eq 'S' and $row[4] eq 'N')
  { $btn = "<input type='image' src='/images/edit.png' name='edt$no' value='Edit' class='huruf1' onClick=\"toedit('$row[10]');\">"; }
  else { $btn=""; }

  $dt = genfuncast::mdytodmy($row[1]);

  print qq~
  <tr bgcolor=$colcolor height=20>
     <td align='center' class="hurufcol" valign='top'>$no </td>
     <td align='left' class="hurufcol" valign='top'><a class=huruflink href="sisasset.cgi?pages=at0015d&recido=$row[10]&ss=$in{ss}">$row[0]</a></td>
     <td align='left' class="hurufcol" valign='top'>$dt</td>
     <td align='left' class="hurufcol" valign='top'>$row[2]</td>
     <td align='left' class="hurufcol" valign='top'>$row[3]</td>
     <td align='left' class="hurufcol" valign='top'>$row[11]</td>
     <td align='left' class="hurufcol" valign='top'>$row[4] ($row[5])</td>
  </tr>
  ~;
  $no++;
}

print qq ~</table>
</form>~;

print qq ~
    <hr width="100" />
</center>
~;
}

;
1

