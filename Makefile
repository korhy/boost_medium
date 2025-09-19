remove_punct=True
remove_stopwords=True
content_only=False
metadata_only=False
model_is_tree=False

help:
	@echo "------ 👌 Available commands:"
	@echo "> make help        - Show this help"
	@echo "> make requirements - Install dependencies"
	@echo "> make clean       - Clean temporary files"
	@echo "> make clean_data  - Clean preprocessed data (force reprocessing)"
	@echo "> make reinstall_package  - Reinstall package"
	@echo "> make train model_name=        - Train the model (with integrated preprocessing)"
	@echo "> make evaluate model_name=    - Evaluate the model"
	@echo "> make run_all model_name=      - run in the order: train -> evaluate"
	@echo " ! Model names: LGBMRegressor, XGBRegressor, GradientBoostingRegressor, Ridge,"
	@echo "   ExtraTreesRegressor, RandomForestRegressor, LinearRegression, ElasticNet"
	@echo ""
	@echo "------ ⚠️  IMPORTANT: Preprocessing is now integrated with training to prevent data leakage"
	@echo "------ ✅ End of commands."

requirements:
	@echo "------ 🔄 Depencies Installation ..."
	pip install -r requirements.txt
	python -m nltk.downloader punkt
	python -m nltk.downloader punkt_tab
	python -m nltk.downloader wordnet
	@mkdir -p raw_data
	@mkdir -p raw_data/medium
	@mkdir -p raw_data/medium/data/machine_learning
	@mkdir -p raw_data/medium/data/deep_learning
	@mkdir -p raw_data/medium/params/machine_learning
	@mkdir -p raw_data/medium/params/deep_learning
	@mkdir -p raw_data/medium/models/machine_learning
	@mkdir -p raw_data/medium/models/deep_learning
	@mkdir -p raw_data/medium/preprocessor/machine_learning
	@mkdir -p raw_data/medium/preprocessor/deep_learning
	@mkdir -p raw_data/medium/metrics/machine_learning
	@mkdir -p raw_data/medium/metrics/deep_learning
	@mkdir -p raw_data/medium/prediction/machine_learning
	@mkdir -p raw_data/medium/prediction/deep_learning
	@echo "------ ✅ Dépendances installées."

reinstall_package:
	@echo "------ 🔄 Reinstalling the package..."
	@pip install --config-settings editable_mode=compat -e .
	@echo "------ ✅ Package reinstalled."

clean:
	@echo "------ 🧹 Cleaning temporary files..."
	@rm -fr **/__pycache__ **/*.pyc
	@rm -fr **/build **/dist
	@rm -fr medium.egg-info
	@rm -f **/*Zone.Identifier
	@echo "------ ✅ Cleaning done."

clean_data:
	@echo "------ 🧹 Cleaning preprocessed data..."
	@rm -f ~/medium/data/df_*processed*.csv
	@echo "------ ✅ Preprocessed data deleted."

clean_models:
	@echo "------ 🧹 Cleaning models and preprocessors..."
	@echo "⚠️  WARNING: This command will delete all models!"
	@echo "Press Ctrl+C to cancel, or wait 5 seconds..."
	@sleep 5
	@rm -f ~/medium/models/*.pickle
	@rm -f ~/medium/preprocessor/*.pickle
	@echo "------ ✅ Models and preprocessors deleted."

test:
	@echo "------ 🔄 Start test ..."
	@pytest -v
	@echo "------ ✅ End!"

lint:
	@echo "------ 🔄 Start lint..."
	@echo "To Do 🆘"
	@echo "------ ✅ End lint!"

# DEPRECATED: Preprocessing is now integrated with training to prevent data leakage
# Use 'make train' instead which handles both preprocessing and training
preprocess_deprecated:
	@echo "------ ❌ DEPRECATED: Separate preprocessing may cause data leakage!"
	@echo "------ ℹ️  Use 'make train' which handles preprocessing correctly."
	@echo "------ ℹ️  Preprocessing is now integrated with training."

train:
	@echo "------ 🔄 Start train (with integrated preprocessing)..."
	@echo "ℹ️  Configuration:"
	@echo "  - Model: $(model_name)"
	@echo "  - Remove punctuation: $(remove_punct)"
	@echo "  - Remove stopwords: $(remove_stopwords)"
	@echo "  - Content only: $(content_only)"
	@echo "  - Metadata only: $(metadata_only)"
	@echo "  - Model is tree: $(model_is_tree)"
	python -c "from medium.interface.main import train; train(model_name='$(model_name)', remove_punct=$(remove_punct), remove_stopwords=$(remove_stopwords), content_only=$(content_only), metadata_only=$(metadata_only), model_is_tree=$(model_is_tree))"
	@echo "------ ✅ End train."

pred:
	@echo "------ 🔄 Start pred ..."
	python -c "from medium.interface.main import pred; pred(model_name='$(model_name)', text='$(text)')"
	@echo "------ ✅ End pred."

evaluate:
	@echo "------ 🔄 Start evaluate ..."
	python -c "from medium.interface.main import evaluate; evaluate(model_name='$(model_name)', remove_punct=$(remove_punct), remove_stopwords=$(remove_stopwords), content_only=$(content_only), metadata_only=$(metadata_only), model_is_tree=$(model_is_tree))"
	@echo "------ ✅ End evaluate."

run_all:
	@echo "------ 🔄 Run all (train + evaluate)..."
	python -c "from medium.interface.main import run_all; run_all(model_name='$(model_name)', remove_punct=$(remove_punct), remove_stopwords=$(remove_stopwords), content_only=$(content_only), metadata_only=$(metadata_only), model_is_tree=$(model_is_tree))"
	@echo "------ ✅ End run all."

# Validation commands
validate_setup:
	@echo "------ 🔍 Validating configuration..."
	@echo "Checking train-only preprocessors:"
	@ls -la ~/medium/preprocessor/*train_only* 2>/dev/null || echo "No train-only preprocessor found"
	@echo ""
	@echo "Checking preprocessed data:"
	@ls -la ~/medium/data/df_*processed*.csv 2>/dev/null || echo "No preprocessed data found"
	@echo "------ ✅ Validation done."

# Service API
as_service:
	uvicorn medium.api.fast:app --reload

# Development helpers
watch_metrics:
	@echo "------ 📊 Watching metrics..."
	@watch -n 2 'ls -lht ~/medium/metrics/ | head -10'

compare_models:
	@echo "------ 📈 Comparing models..."
	@python -c "import pandas as pd; import glob; files = glob.glob('~/medium/metrics/*.csv'); [print(f'{f}: MAE = {pd.read_csv(f)[\"mae\"].mean():.4f}') for f in files[-5:]]"

# Full pipeline with best model
production_ready:
	@echo "------ 🚀 Preparing for production..."
	@make clean
	@make train model_name=XGBRegressor
	@make evaluate model_name=XGBRegressor
	@echo "------ ✅ Model ready for production!"
