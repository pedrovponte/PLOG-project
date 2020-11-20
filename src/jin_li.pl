:-consult('play.pl').
:-consult('display.pl').
:-consult('inputs.pl').
:-consult('utils.pl').
:-consult('game_logic.pl').
:-consult('menu.pl').
:-use_module(library(system)).

jin_li :- 
	printMenu,
	selectMenuOption.