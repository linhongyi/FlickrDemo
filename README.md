# FlickrDemo

MVVM + coordinator

1. Coordinator
RootCoordinator (ViewController 過場)

2. ViewController
MaviewController （搜尋輸入頁)
FlickrListViewController (搜尋結果頁面）
FavoriteViewController (我的最愛頁面)

3. Service
DownloadImageService (下載圖檔)
ImageCachedService (圖檔暫存)
LocalImageService (本地端圖檔存取)
StorageService (本地端模型儲存)

4. ViewModel
FlickrAPIViewModel (access API資料)
FlickrListViewModel (相簿呈現資料)
