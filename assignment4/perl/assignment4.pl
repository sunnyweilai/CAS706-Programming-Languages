# WWW::Mechanize:used for performing google searching
use WWW::Mechanize;
# Web::Scraper:used for parsing the html and finding all errors and warnings with tag 'li'
use Web::Scraper;
use URI;
use Encode;
use 5.18.2;
use strict;
use warnings;

my $mech = new WWW::Mechanize;
my $option = 500; 
my $google = 'http://www.google.ca/search?q='; 

# input the keywords 
print "Enter what you want to search:";
my $input = <STDIN>;;
chomp($input);
my @dork = ($input);

        #declare variables
        my $max = 0;
        my $link;
        my $sc = scalar(@dork);
        my $check;

        # define a scraper to find all errors and warnings with tag 'li'
        my $outputs = scraper{
                        process 'div#results > ol > li > p',"statics[]" => 'TEXT';        
                    };
        # start google searching(use reference[1])
        for my $i ( 0 .. $sc ) {

            while ( $max <= $option ) {
                $mech->get( $google . $dork[$i] . "&start=" . $max );

                #get all the google results
                foreach $link ( $mech->links() ) {
                    my $google_url = $link->url;
                    if ( $google_url !~ /^\// && $google_url !~ /google/ ) {
                    my $w3c = 'https://validator.w3.org/nu/?doc=';
                    # concatenate two urls 
                    my $result =  $w3c.$google_url;
                    say $result;
                    # (use reference[2])call the scraper to do the scraping (find all errors and warnings)
                    $check = $outputs -> scrape(URI -> new($result));
                    for my $output (@{$check->{statics}}){
                        print Encode::encode("utf8","$output\n");
                    }
                    }
                    }
                     $max += 1;
                }

            }
#------------------------------Reference-----------------------------

# [1]cyber-guard.. answers for stackoverflow
#  [online]Available at< https://stackoverflow.com/questions/4241129/tiny-runable-wwwmechanize-examples-for-the-beginner > (2010/11/21)

# [2]CPAN.. Web::Scraper - Web Scraping Toolkit using HTML and CSS Selectors or XPath expressions [online]Available at< http://search.cpan.org/~miyagawa/Web-Scraper-0.38/lib/Web/Scraper.pm >
