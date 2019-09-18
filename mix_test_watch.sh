#!/bin/bash
rerun --dir "lib" --dir test --pattern "**/*.{ex,exs}" --exit --clear --name "Tests" -- mix test