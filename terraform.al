#!/bin/bash

tout(){ trf output ${@:1} ;}
tv(){ trf validate ${@:1} ;}
tp(){ trf plan ${@:1} ;}
ta(){ trf apply ${@:1} ;}
ti(){ trf init -force-copy -input=false ;}
