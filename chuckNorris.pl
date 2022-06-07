:- use_module(library(http/http_open)).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/html_write)).
:- use_module(library(http/json)).

:- http_handler('/', chuckNorris, []).

handle_request2(_Request) :-
    load_html('main.html', DOM, []),
    phrase(html(DOM), Tokens),
    html_print_length(Tokens, Len),
    format('Content-type: text/html; charset=UTF-8~n'),
    format('Content-length: ~d~n~n', [Len]),
    print_html(Tokens).


chuckNorris(_Request) :-
    http_open('https://api.chucknorris.io/jokes/random?category=dev', In, []),
    json_read_dict(In, JsonChuck),

    A = JsonChuck.value,

    reply_html_page(
        [  title('Hello')
        ],

        body([
        style(["height: 100vh;
            width: 100vw;
            display: flex;
            align-items: center;
            background-image: url('https://cdn.wallpapersafari.com/67/13/OuKBvw.jpg');
            background-size: cover;
            background-position: bottom"])], 
        [
            h1([style("width: 30vw; position: absolute; left: 20vw ")], A),
            img([style("height:60vh; position:absolute; right: 40vh"), 
                src('https://img2.gratispng.com/20171220/dwq/chuck-norris-png-5a3a450256e6c6.4207585115137681943566730.jpg')])
        ])
    ).

server(Port) :-
    http_server(http_dispatch, [port(Port)]).

:- initialization(server(8000)).