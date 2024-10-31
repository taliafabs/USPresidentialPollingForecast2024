# U.S. Presidential Polling Forecast 2024

## Overview

This repository contains the code and data used to complete this 2024 U.S. Presidential Election Forecast. It was created by Talia Fabregas, Aliza Mithwani, and Fatimah Yunusa. This U.S. Election Forecast was performed using Presidential general election polling data (current cycle), downloaded from FiveThirtyEight on October 29, 2024 and the poll-of-polls method. Polling data published after this date was not considered.

## File Structure

The repository is structured as follows:

-   `data/raw_data` contains the raw data that was obtained from FiveThirtyEight on October 29, 2024.
-   `data/analysis_data` contains the cleaned datasets that were constructed and used for the analysis.
-   `model` contains fitted models. 
-   `other` contains details about LLM usage/interactions and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document, the PDF of the paper, and the reference bibliography file. 
-   `scripts` contains the R scripts used to simulate, download and clean data, as well as the script used to build the models.


## Statement on LLM usage

Aspects of this code were written and debugged with the help of a large language model, ChatGPT. The entire interaction history with ChatGPT is available in other/llmusage.txt. Comments indicating the use of ChatGPT are included in the parts of the code that were written using the assistance of ChatGPT.

## Some checks

- [ ] Remove files that you're not using
- [ ] Update comments in R scripts
- [ ] Remove this checklist
