# U.S. Presidential Polling Forecast 2024

## Overview

This repository contains... 2024 U.S. Presidential Election. Talk about the data that was used.
The presidential polling data was obtained from 538 on October 21, 2024. Polling data published after this date did not factor into the analysis presented in this paper in any way, shape, or form.

## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from 538.
-   `data/analysis_data` contains the cleaned dataset that was constructed and later used for the analysis.
-   `model` contains fitted model. 
-   `other` contains relevant literature, details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.


## Statement on LLM usage

Aspects of this code were written and debugged with the help of a large language model, ChatGPT. The entire interaction history with ChatGPT is available in other/llmusage.txt. Comments indicating the use of ChatGPT are included in the parts of the code that were written using the assistance of ChatGPT.

## Some checks

- [ ] Change the rproj file name so that it's not starter_folder.Rproj
- [ ] Change the README title so that it's not Starter folder
- [ ] Remove files that you're not using
- [ ] Update comments in R scripts
- [ ] Remove this checklist
