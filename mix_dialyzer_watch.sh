#!/bin/bash
rerun --dir "lib" --pattern "**/*.ex" --exit --clear --name "Dialyzer" -- mix dialyzer