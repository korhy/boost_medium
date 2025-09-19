# 📊 Medium Article Recommendation Prediction Project
## 📑 Project Overview

This project aims to predict the number of recommendations that Medium articles will receive. Specifically, it predicts the target variable `log1p_recommends` (the logarithm of the number of recommendations + 1) based on article features.

## 📋 Project Description

The goal is to analyze Medium article data and develop a recommendation prediction model, optimizing for the best performance using the MAE (Mean Absolute Error) metric.

The project is based on an old Kaggle competition : [How good is your Medium article?](https://www.kaggle.com/competitions/how-good-is-your-medium-article/overview)

All data used in this project comes from the dataset provided by Kaggle :
 - The training set is comprised of 62313 articles published on Medium before July 1, 2017
 - The test set contains 34645 articles published on Medium from July 1, 2017 till March 3, 2018

## ⚙️ Installation and Setup

### 📊 Data

Download the dataset from [Kaggle](https://www.kaggle.com/competitions/how-good-is-your-medium-article/data)

- Required files:
    - `train.json`: Training data (62,313 articles)
    - `test.json`: Test data (34,645 articles)
    - `train_log1p_recommends.csv`: Target variable for training

For the training, we have extract into files:
- From train.json :
    - 43619 lines to train our models
    - 18694 (left over) lines for the evaluation

```
head -n 43619 train.json > X_train.json
tail -n +43620 train.json > X_test.json
```

- Same for train_log1p_recommends.csv :
    - 43619 lines to train our models
    - 18694 (left over) lines from train.json for the evaluation

```
head -n 43619 train_log1p_recommends.csv > y_train.csv
tail -n +43620 train_log1p_recommends.csv > y_test.csv
```

In result, we have 4 files X_train.json, X_test.json, y_train.csv and y_test.csv

The test.json file will be used for the prediction App only

- Data structure:
    Each article contains:
    - `_id`: Unique identifier
    - `url`: Article URL
    - `published`: Publication date
    - `title`: Article title
    - `author`: Author information
    - `content`: Article HTML content
    - `meta_tags`: Additional metadata

### Prerequisites

- Python 3.10.6+

### Installation

- Clone the repository:
  ```bash
  git clone git@github.com:korhy/boost_medium.git
  cd boost_medium
  ```

- Install dependencies:
  ```
  make requirements
  ```

- Copy the example environment file:
  ```
  cp .env.sample .env
  ```

- Edit the `.env` file with your paths:
  ```
  nano .env    # or use your preferred editor
  ```

- Complete with the path of the data files that we have create above:
```
DATA_TRAIN=path_to_your/X_train.json
DATA_TEST=path_to_your/X_test.json
DATA_LOG_RECOMMEND=path_to_your/y_train.csv
DATA_TEST_LOG_RECOMMEND=path_to_your/y_test.csv
```
>[!TIP]
>Put them in the raw_data folder at the root of the projet, this one is already gitignore 😉


### 📝 License

This project is licensed under the MIT License.

### 🙏 Acknowledgements

- Team Medium
- LeWagon
