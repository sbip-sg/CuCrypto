#include <gtest/gtest.h>
#include <CuCrypto/keccak.cuh>
#include <cuda_runtime.h>

// Kernel to compute Keccak hash on the GPU
__global__ void keccak_kernel(const uint8_t* data, size_t data_len, uint8_t* hash, size_t hash_len) {
    CuCrypto::keccak::sha3(data, data_len, hash, hash_len);
}


TEST(CUDAKeccakTest, NullAssertions) {
    uint8_t data[32] = {0};
    uint8_t hash[32];
    uint8_t* d_data;
    uint8_t* d_hash;

    cudaDeviceReset();

    cudaMalloc(&d_data, sizeof(data));
    cudaMalloc(&d_hash, sizeof(hash));
    cudaMemcpy(d_data, data, sizeof(data), cudaMemcpyHostToDevice);

    keccak_kernel<<<1, 1>>>(d_data, 0, d_hash, 32);
    cudaDeviceSynchronize();
    cudaMemcpy(hash, d_hash, sizeof(hash), cudaMemcpyDeviceToHost);

    cudaFree(d_data);
    cudaFree(d_hash);

    cudaDeviceReset();

    // Expected hash value
    uint8_t expected_hash[32] = {
        0xc5, 0xd2, 0x46, 0x01, 0x86, 0xf7, 0x23, 0x3c,
        0x92, 0x7e, 0x7d, 0xb2, 0xdc, 0xc7, 0x03, 0xc0,
        0xe5, 0x00, 0xb6, 0x53, 0xca, 0x82, 0x27, 0x3b,
        0x7b, 0xfa, 0xd8, 0x04, 0x5d, 0x85, 0xa4, 0x70
    };

    for (int i = 0; i < 32; i++) {
        EXPECT_EQ(hash[i], expected_hash[i]);
    }
}

TEST(CUDAKeccakTest, BasicAssertions) {
    uint8_t data[32] = {
        0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8,
        0x9, 0xa, 0xb, 0xc, 0xd, 0xe, 0xf, 0x10,
        0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
        0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f, 0x20
    };
    uint8_t hash[32];
    uint8_t* d_data;
    uint8_t* d_hash;

    cudaDeviceReset();

    cudaMalloc(&d_data, sizeof(data));
    cudaMalloc(&d_hash, sizeof(hash));
    cudaMemcpy(d_data, data, sizeof(data), cudaMemcpyHostToDevice);

    keccak_kernel<<<1, 1>>>(d_data, 0, d_hash, 32);
    cudaDeviceSynchronize();
    cudaMemcpy(hash, d_hash, sizeof(hash), cudaMemcpyDeviceToHost);

    cudaFree(d_data);
    cudaFree(d_hash);

    cudaDeviceReset();

    // Expected hash value
    uint8_t expected_hash[32] = {
        0x52, 0xb3, 0xf5, 0x3f, 0xf1, 0x96, 0xa2, 0x8e,
        0x7d, 0x2d, 0x01, 0x28, 0x3e, 0xf9, 0x42, 0x70,
        0x70, 0xbd, 0xa6, 0x41, 0x28, 0xfb, 0x56, 0x30,
        0xb9, 0x7b, 0x6a, 0xb1, 0x7a, 0x8f, 0xf0, 0xa8
    };

    for (int i = 0; i < 32; i++) {
        EXPECT_EQ(hash[i], expected_hash[i]);
    }
}

TEST(KeccakTest, NullAssertions) {
    uint8_t data[32] = {0};
    uint8_t hash[32];
    CuCrypto::keccak::sha3(data, 0, hash, 32);

    // Expected hash value (example, replace with actual expected value)
    uint8_t expected_hash[32] = {
        0xc5, 0xd2, 0x46, 0x01, 0x86, 0xf7, 0x23, 0x3c,
        0x92, 0x7e, 0x7d, 0xb2, 0xdc, 0xc7, 0x03, 0xc0,
        0xe5, 0x00, 0xb6, 0x53, 0xca, 0x82, 0x27, 0x3b,
        0x7b, 0xfa, 0xd8, 0x04, 0x5d, 0x85, 0xa4, 0x70
    };

    for (int i = 0; i < 32; i++) {
        EXPECT_EQ(hash[i], expected_hash[i]);
    }
}

TEST(KeccakTest, BasicAssertions) {
    uint8_t data[32] = {0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xa, 0xb, 0xc, 0xd, 0xe, 0xf, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f, 0x20};
    uint8_t hash[32];
    CuCrypto::keccak::sha3(data, 32, hash, 32);

    // Expected hash value (example, replace with actual expected value)
    uint8_t expected_hash[32] = {
        0x52, 0xb3, 0xf5, 0x3f, 0xf1, 0x96, 0xa2, 0x8e,
        0x7d, 0x2d, 0x01, 0x28, 0x3e, 0xf9, 0x42, 0x70,
        0x70, 0xbd, 0xa6, 0x41, 0x28, 0xfb, 0x56, 0x30,
        0xb9, 0x7b, 0x6a, 0xb1, 0x7a, 0x8f, 0xf0, 0xa8
    };

    for (int i = 0; i < 32; i++) {
        EXPECT_EQ(hash[i], expected_hash[i]);
    }
}