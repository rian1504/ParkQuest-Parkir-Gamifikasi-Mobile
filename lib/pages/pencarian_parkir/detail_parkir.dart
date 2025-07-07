import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:parkquest_parkir_gamifikasi/constants.dart';
import 'package:parkquest_parkir_gamifikasi/Controllers/park_search_controller.dart';
import 'package:get/get.dart';
import 'package:parkquest_parkir_gamifikasi/models/park_search/park_data.dart';
// import 'package:parkquest_parkir_gamifikasi/models/park_search/park_recommendation.dart';
import 'package:timeago/timeago.dart' as timeago;

class DetailParkir extends StatefulWidget {
  const DetailParkir({super.key});

  @override
  State<DetailParkir> createState() => _DetailParkirState();
}

class _DetailParkirState extends State<DetailParkir> {
  // Park Data
  final ParkSearchController _parksearchcontroller =
      Get.put(ParkSearchController());

  // Variables for lazy loading
  final ScrollController _scrollController = ScrollController();
  int _displayedItemCount = 5;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Scroll listener for lazy loading
  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _displayedItemCount <
            _parksearchcontroller.datasParkRecommendation.value.length) {
      _loadMoreItems();
    }
  }

  // Function to load more items
  void _loadMoreItems() {
    setState(() {
      _isLoadingMore = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _displayedItemCount = _displayedItemCount + 5 >
                _parksearchcontroller.datasParkRecommendation.value.length
            ? _parksearchcontroller.datasParkRecommendation.value.length
            : _displayedItemCount + 5;
        _isLoadingMore = false;
      });
    });
  }

  // Title Text
  Widget _buildTitleText(String text) {
    return Row(
      children: [
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Text
  Widget _buildText(String text) {
    return Row(
      children: [
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  // Colored Box
  Widget _buildColoredBox(Color color) {
    return SizedBox(
      width: 24,
      height: 24,
      child: DecoratedBox(
        decoration: BoxDecoration(color: color),
      ),
    );
  }

  // Card
  Widget _buildCard(
    int id,
    Widget image,
    String name,
    String time,
    String description,
  ) {
    return Material(
      child: Container(
        height: 75,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(
          bottom: 20,
          left: 20,
          right: 20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: InkWell(
          onTap: () async {
            await _parksearchcontroller.parkRecommendationDetail(
              parkRecommendationId: id,
            );
          },
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Foto Profil
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: image,
                  ),
                ],
              ),
              SizedBox(width: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Nama
                      Text(
                        name,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 10),
                      // Waktu
                      Text(
                        time,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Catatan
                      SizedBox(
                        width: 225,
                        child: Text(
                          description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final parkAreaData = _parksearchcontroller.parkAreaData.value!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFEC827),
        title: Text(
          parkAreaData.parkName,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            CupertinoIcons.chevron_left,
            color: Colors.white,
          ),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            // Banner Image
            SizedBox(
              width: double.infinity,
              child: Image.network(
                storageUrl + parkAreaData.parkImage,
                fit: BoxFit.cover,
                height: 200,
              ),
            ),
            // Tab Bar
            TabBar(
              onTap: (index) {
                if (index == 1) {
                  _parksearchcontroller.parkRecommendation(
                    parkAreaId: parkAreaData.id,
                  );
                  // Reset displayed items when switching to recommendations tab
                  setState(() {
                    _displayedItemCount = 5;
                  });
                }
              },
              indicatorColor: Color(0xFFFEC827),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 3,
              tabs: [
                Tab(text: 'Informasi'),
                Tab(text: 'Rekomendasi'),
              ],
            ),
            // Content
            Expanded(
              child: TabBarView(
                children: [
                  // Tab Informasi
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Kapasitas Kendaraan
                          SizedBox(height: 32),
                          _buildTitleText('Kapasitas Kendaraan'),
                          SizedBox(height: 16),
                          _buildText('Motor'),
                          SizedBox(height: 8),
                          _buildText(parkAreaData.parkCapacity.toString()),
                          // Perkiraan Ketersediaan Parkir
                          SizedBox(height: 20),
                          _buildTitleText('Ketersediaan Parkir'),
                          SizedBox(height: 16),

                          Obx(() {
                            if (_parksearchcontroller.isLoading.value) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (_parksearchcontroller
                                .datasParkData.value.isEmpty) {
                              return Center(
                                  child: Text('Data tidak ditemukan'));
                            }

                            return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _parksearchcontroller
                                    .datasParkData.value.length,
                                itemBuilder: (context, index) {
                                  final ParkDataModel data =
                                      _parksearchcontroller
                                          .datasParkData.value[index];

                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          _buildText("${data.startHour}.00"),
                                          SizedBox(height: 12),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          _buildText("-"),
                                          SizedBox(height: 12),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          _buildText("${data.endHour}.00"),
                                          SizedBox(height: 12),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          _buildText(
                                              "   ${data.available} Tersedia"),
                                          SizedBox(height: 12),
                                        ],
                                      ),
                                      SizedBox(width: 24),
                                      Column(
                                        children: [
                                          if (data.available <= 10)
                                            _buildColoredBox(Color(0xFFF20707)),
                                          if (data.available > 10 &&
                                              data.available < 20)
                                            _buildColoredBox(Color(0xFFF8FD07)),
                                          if (data.available >= 20)
                                            _buildColoredBox(Color(0xFF20FF0C)),
                                          SizedBox(height: 12),
                                        ],
                                      ),
                                    ],
                                  );
                                });
                          }),
                          // Keterangan
                          SizedBox(height: 60),
                          _buildTitleText('KET'),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  _buildColoredBox(Color(0xFF20FF0C)),
                                  SizedBox(width: 4),
                                  _buildText('Sepi'),
                                ],
                              ),
                              Row(
                                children: [
                                  _buildColoredBox(Color(0xFFF8FD07)),
                                  SizedBox(width: 4),
                                  _buildText('Lumayan'),
                                ],
                              ),
                              Row(
                                children: [
                                  _buildColoredBox(Color(0xFFF20707)),
                                  SizedBox(width: 4),
                                  _buildText('Ramai'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Tab Rekomendasi
                  NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      // Let the scroll controller handle the notification
                      return false;
                    },
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Obx(() {
                          if (_parksearchcontroller.isLoading.value) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFFEC827),
                              ),
                            );
                          }
                          if (_parksearchcontroller
                              .datasParkRecommendation.value.isEmpty) {
                            return Center(child: Text('Data tidak ditemukan'));
                          }

                          // Take only the displayed items
                          final displayedItems = _parksearchcontroller
                              .datasParkRecommendation.value
                              .take(_displayedItemCount)
                              .toList();

                          return Column(
                            children: [
                              // Display the items
                              ...displayedItems.map((data) {
                                return _buildCard(
                                  data.id,
                                  data.user.avatar == null
                                      ? Icon(Icons.person)
                                      : Image.network(
                                          storageUrl + data.user.avatar,
                                        ),
                                  data.user.name,
                                  timeago.format(data.createdAt),
                                  data.description,
                                );
                              }),
                              // Loading indicator at the bottom
                              if (_isLoadingMore)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFFFEC827),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
