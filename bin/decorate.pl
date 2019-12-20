#!/usr/bin/perl -w
#
# DECORATE
#
# This script provides a set of "bare" HTML files (which contain the things
# you'd put between <BODY>...</BODY>) with standard decorations. Makes it
# easy to use style templates, without stylesheets, server-side includes or
# scripts.
#
# The input files are named on the command line; last argument is the target
# directory.
#
# Input documents may contain any number of metadata items. Each item starts
# with <!-- DECO and may contain an arbitrary number of attr=value pairs
# before the comment is closed.
#
# Available attributes are currently:
#
# TITLE			- Defines <TITLE> element in header
# DESCRIPTION		- Defines <META ITEM="DESCRIPTION"> element in header
# KEYWORDS		- Defines <META ITEM="KEYWORDS"> element in header
# LOGO			- Defines <IMG SRC=...> element for title
#
#
# Author: Emile van Bergen, emile@evbergen.xs4all.nl
#
##
#
# Configure: document header

$BORDER=0;

sub stdopen {
	(my $pairs) = @_;

	my $ret = "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
<HTML>\n\n<!-- Document generated by decorate.pl -->\n\n";

	$ret .= "<HEAD>\n";
	$ret .= "<TITLE>$$pairs{'title'}</TITLE>\n" if $$pairs{'title'};
	$ret .= "<META NAME=DESCRIPTION CONTENTS=\"$$pairs{'description'}\">\n"
		if $$pairs{'description'};
	$ret .= "<META NAME=KEYWORDS CONTENTS=\"$$pairs{'keywords'}\">\n"
		if $$pairs{'keywords'};
	$ret .= "</HEAD>\n";

	$ret .= "
<!--
<BODY BGCOLOR=\"#6b7eb2\" TEXT=\"#000000\" BACKGROUND=\"images/back.jpg\"
      LINK=\"#0043ff\" VLINK=\"#0043ff\" ALINK=\"#6b7eb2\">
-->
<BODY BGCOLOR=\"#6b7eb2\" TEXT=\"#000000\"
      LINK=\"#0043ff\" VLINK=\"#0043ff\" ALINK=\"#6b7eb2\">

<!-- EXTRA table around left/right tables -->

<TABLE BORDER=$BORDER CELLPADDING=0 CELLSPACING=0><TR VALIGN=TOP>
<TD>

<!-- Table on left for menu table -->

<TABLE BORDER=$BORDER CELLPADDING=4 CELLSPACING=6>
<TR BGCOLOR=\"#ffffff\" ALIGN=CENTER><TD>

<!-- INSERT_MENU -->

</TD></TR>
</TABLE>

<!-- End of table on left -->

</TD><TD>	<!-- next column in EXTRA table -->

<!-- Table on right for document table -->

<TABLE BORDER=$BORDER CELLPADDING=4 CELLSPACING=6>
<TR BGCOLOR=\"#ffffff\" ALIGN=CENTER><TD>

<!-- Document table -->

<TABLE BORDER=$BORDER CELLPADDING=1 CELLSPACING=0>\n";

	if ($$pairs{'title'}) {

		$ret .= "
<!-- Title row -->

<TR BGCOLOR=\"#ffffff\" VALIGN=TOP>

<TD>
<FONT COLOR=\"#000000\" SIZE=\"+1\"><B>
$$pairs{'title'}
</B></FONT><HR NOSHADE SIZE=1>
</TD>";

		$ret .= "
<TD ROWSPAN=2 ALIGN=RIGHT>
<IMG SRC=\"$$pairs{'logo'}\" ALT=\"Logo\">
</TD>" if $$pairs{'logo'};

		$ret .= "
</TR>

<!-- Empty row -->

<TR><TD><BR><BR></TD></TR>\n";

	}

	$ret .= "\n<!-- Document row -->\n\n<TR><TD";
	$ret .= " COLSPAN=2" if $$pairs{'logo'};
	$ret .= ">\n";

	$ret;
}


##
#
# Configure: document trailer

sub stdclose {
	my $date = localtime;
	"
<!-- End of document table -->

<P></P>
<SCRIPT LANGUAGE=\"JavaScript\">
<!--
url='http://host.e-advies.nl/track/blackpixel.gif?ref=' + escape(document.referrer);
document.write('<IMG SRC=\"' + url +  '\" WIDTH=1 HEIGHT=1 ALT=\"s\">');
// -->
</SCRIPT>
<NOSCRIPT>
<IMG SRC=\"http://host.e-advies.nl/track/blackpixel.gif\" WIDTH=1 HEIGHT=1 ALT=\"n\">
</NOSCRIPT>

<P ALIGN=CENTER><FONT COLOR=\"#6b7eb2\" SIZE=\"-2\">Generated on $date by <A HREF=\"tools/decorate.pl\">decorate.pl</A> / <A HREF=\"tools/menuize.pl\">menuize.pl</A></FONT>

</TD></TR></TABLE>

<!-- End of table on right -->

</TD></TR></TABLE>

<!-- End of EXTRA table -->

</TD></TR></TABLE>

</BODY>

</HTML>
";

}


##
#
# Main


# Check args
die("Not enough arguments!\n") unless $#ARGV >= 1;
my $outputdir = pop(@ARGV);

# Loop through files on command line
for my $file (@ARGV) {

	# Read file first time, to obtain attr/value pairs
	open(IN, $file) or die("Cannot open input file $file: $!\n");

	$/ = '-->';
	my %pairs = ();
	while(<IN>) {
		s/.*<!-- DECO//s or next;	# Delete before; skip if none
		s/-->.*//s;			# Delete content after close

		# We now have a series of attrs and values left
		while(s/\s*			# optional whitespace
			([A-Za-z0-9_]+)		# Attribute ($1)
			\s*=\s*			# optional ws., = sign, opt. ws.
			(
			  "(([^"]|\\")*[^\\])"| # quoted Value ($3), or
			  ([^\s]+)		# single word Value ($5)
			)
			(
			  \s+|			# ended by one or more spaces
			  -->|			# or end-of-tag
			  $			# or end-of-record
			)//x) {

			my $atr = lc $1;	# Attributes are lowercase
			my $val = $5 || $3;	# Take single word or quoted
			$pairs{$atr} = $val;	# Save into hash
		}
	}

	# Open output
	my $outf = $file; $outf =~ s/.*\///; $outf = "$outputdir/$outf";
	open(OUT, "> $outf") or die("Cannot open output file $outf: $!\n");

	# Output opening
	print OUT stdopen(\%pairs);

	# Now copy input unchanged, except for DECO pseudo-tags
	$/ = '-->';
	seek(IN, 0, 0);
	while(<IN>) {
		s/<!-- DECO.*-->//s;
		print OUT $_;
	}

	# Output closing
	print OUT stdclose(\%pairs);

	close(OUT) || die("Could not close output $outf: $!\n");
	close(IN) || die("Could not close input $file: $!\n");
}
