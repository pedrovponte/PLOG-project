:-consult('play.pl').
:-consult('display.pl').
:-consult('inputs.pl').
:-consult('utils.pl').
:-consult('game_logic.pl').
:-consult('menu.pl').
:-consult('ai.pl').
:-use_module(library(system)).
:-use_module(library(random)).
:-use_module(library(lists)).

jin_li :- 
	printMenu,
	selectMenuOption.