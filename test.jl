using Test
include("main.jl")

@testset "Simple test case" begin
    cases = Dict(:A => [
            2 5 9 300
            7 3 6 200
            4 8 3 200
            200 400 100 700
        ], :B =>
            [
                10 14 8 20
                12 15 10 30
                22 32 16 40
                40 30 20 90
            ],
        :C => [
            0 0 0 0 0 0 120
            0 0 0 0 0 0 300
            0 0 0 0 0 0 410
            0 0 0 0 0 0 250
            100 210 200 250 200 120 1080]
    )
    true_answer = Dict(:B => [
            20 0 0 0
            20 10 0 0
            0 20 20 0
            0 0 0 90
        ], :A => [
            200 100 0 0
            0 200 0 0
            0 100 100 0
            0 0 0 700
        ],
        :C => [
            100 20 0 0 0 0 0
            0 190 110 0 0 0 0
            0 0 90 250 70 0 0
            0 0 0 0 130 120 0
            0 0 0 0 0 0 1080
        ]
    )

    for (key, value) in cases
        @testset "Test case $key" begin
            @test find_initial_solution(value) == true_answer[key]
        end
    end
end

"done"