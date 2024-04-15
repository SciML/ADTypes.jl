for ad in every_ad()
    @test identity.(ad) == ad
end
