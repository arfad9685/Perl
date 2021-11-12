sub sis_supplier_a {
	style_module::use_warning();
	
	sub add_ccost {
		( $d1, $d2, $d3, $d4, $d5, $d6, $d7, $d8, $d9, $d10, $d11 ) = @_;
		if ($d1) {
			$up_menu = $dbh->do(
				"INSERT INTO M_SUPPLIER (VENDOR_ID, VENDOR_NAME, VENDOR_NAME_ALT, VENDOR_TIPE, TERMS_ID, CARA_BYR, ISTAX, ISAKTIF, ISALL, KONTAK, PHONE) VALUES ('$d1','$d2','$d3','$d4','$d5','$d6','$d7','$d8','$d9','$d10','$d11')"
			);
			
			if ( $up_menu == 0 ) {
				style_module::use_chkerror($dbh);
				return 'Cancel Proses.';
			}
			else {
				return 'Data sudah tersimpan.';
			}
		}
	}
	
	@cols = ("Vendor ID", "Vendor Name", "Vendor Name Alt", "Vendor Tipe", "Terms ID",  "Cara Bayar", "Is Tax", "Is Aktif", "Is All", "Kontak", "Phone");
	@name = ("VendorID", "VendorName", "VendorNameAlt", "VendorTipe", "TermsID",  "CaraBayar", "IsTax", "IsAktif", "IsAll", "Kontak", "Phone");
	@length = ( "10", "50", "50", "20", "5", "1", "1", "1", "1", "60", "60" );
	@type   = ("textbox",  "textbox", "textbox", "query", "query", "select", "select", "select", "select",  "textbox", "textbox");
	@query   = ("",  "", "", "select tipe_id, tipe_nama from m_supplier_tipe order by tipe_id", "select top_id, top_id as top_name from m_supplier_top order by top_id", "G/T", "Y/N", "Y/N", "Y/N",  "", "");
	
	if ( $in{add} ) {
		$errormsg = add_ccost($in{VendorID}, $in{VendorName}, $in{VendorNameAlt},
							  $in{VendorTipe}, $in{TermsID}, $in{CaraBayar}, $in{IsTax},
							  $in{IsAktif}, $in{IsAll}, $in{Kontak}, $in{Phone}
		);
	}
	
	print qq~
		<p><br>
		<table width=700 border="0" cellspacing="1" cellpadding="1">
		<tr height="24" bgcolor=$header>
			<td colspan=3 align=center class="hurufcol"><strong>ADD SUPPLIER</strong></td>
		</tr>
	~;
	
	if ( !$up_menu ) {
		print qq~
			<form method=post action="/cgi-bin/colorbox.cgi" onSubmit="return warning('Simpan Data');">
				<input name="pages" type="hidden" value=sis_supplier_a>
				<input name="ss" type="hidden" value="$in{ss}">
				<input name="id" type="hidden" value="$in{id}">
				<input name="lok_prg" type="hidden" value="$in{lok_prg}">
				<input name="pageid" type="hidden" value='$tmp_tgl[3]'>
				<input name="menuid" type="hidden" value=$in{menuid}>
		~;
		
		for ( $i = 0 ; $i < scalar(@cols) ; $i++ ) {
			if ( $type[$i] eq "textbox" ) {
				print qq~
					<tr>
						<td align="left" bgcolor=$colcolor class="hurufcol">
							&nbsp;~. $cols[$i] . qq~
						</td>
						<td align="left" class="huruf1">:</td>
						<td align="left" class="huruf1">
							<input type=text size="$length[$i]" name="$name[$i]" class="huruf1" maxlength="$length[$i]">
						</td>
					</tr>
				~;
			}
			elsif ( $type[$i] eq "query" ) {
				print qq~
					<tr>
						<td align="left" bgcolor=$colcolor class="hurufcol">&nbsp;~
						. $cols[$i] . qq~</td>
						<td align="left" class="huruf1">:</td>
						<td align="left" class="hurufcol">
						<select name="~ . $name[$i] . qq~" class="huruf1">~;
							$tbl_tree = $dbh->prepare(
								$query[$i]
							);
							$tbl_tree->execute();
							while ( @tree = $tbl_tree->fetchrow_array() ) {
								print qq~<option value="$tree[0]">$tree[1]</option>~;
							}	
							print qq~
						</select>
						</td>
					</tr>
				~;
			}
			elsif ( $type[$i] eq "select" ) {
				print qq~
					<tr>
						<td align="left" bgcolor=$colcolor class="hurufcol">&nbsp;~
						. $cols[$i] . qq~</td>
						<td align="left" class="huruf1">:</td>
						<td align="left" class="hurufcol">
						<select name="~ . $name[$i] . qq~" class="huruf1">~;
							@val = split("/", $query[$i]);
							for(my $c=0; $c<scalar(@val);$c++) {
								print qq~<option value="$val[$c]">$val[$c]</option>~;
							}	
							print qq~
						</select>
						</td>
					</tr>
				~;
			}
		}
		print qq~
		<tr>
			<td colspan=3 align="left"><input type="submit" name="add" value="Submit" class="button button_green"></td>
		</tr>
		</form>~;
	}
	print qq~
		</table>
		<p>
		<hr width="100" /> ~
		. $errormsg . qq~ </center>
	~;
}

1
	
		