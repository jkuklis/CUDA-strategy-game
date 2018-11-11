all: clean premain

premain:
	nvcc -o premain premain.cu

clean:
	rm -rf premain
