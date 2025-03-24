# Crypto SwiftUI

A modern iOS cryptocurrency tracking application built with SwiftUI, featuring real-time price updates, portfolio management, and detailed coin information.

## Features

- 📊 Real-time cryptocurrency price tracking
- 💼 Portfolio management system
- 🔍 Advanced search functionality
- 📱 Beautiful and intuitive SwiftUI interface
- 📈 Detailed coin statistics and charts
- 🔄 Live data updates
- 🎨 Custom theme and styling
- 📱 Responsive design for all iOS devices

## Project Structure

```
Crypto_SwiftUI/
├── Core/                 # Core application components
│   ├── Home/            # Home screen related views
│   └── Detail/          # Detail view components
├── Models/              # Data models
├── Services/            # Network and data services
├── Utilities/           # Helper functions and extensions
├── Extensions/          # Swift extensions
└── Assets.xcassets/     # Application assets
```

## Technical Details

- **Framework**: SwiftUI
- **Architecture**: MVVM (Model-View-ViewModel)
- **Data Management**: Combine framework
- **Networking**: Async/await for API calls
- **State Management**: @StateObject and @EnvironmentObject

## Key Components

### Views
- `HomeView`: Main dashboard with live prices and portfolio
- `PortfolioView`: Portfolio management interface
- `DetailView`: Detailed coin information and statistics
- `CoinRowView`: Reusable coin list item component

### ViewModels
- `HomeViewModel`: Manages home screen data and business logic
- `PortfolioViewModel`: Handles portfolio-related operations

### Models
- `CoinModel`: Core cryptocurrency data model
- `PortfolioModel`: Portfolio management data structure

## Features in Detail

### Home Screen
- Live cryptocurrency prices
- Search functionality
- Sortable columns (Rank, Price, Holdings)
- Smooth animations and transitions
- Portfolio toggle

### Portfolio Management
- Add/remove coins to portfolio
- Track holdings and value
- Real-time portfolio updates
- Custom sorting options

### Coin Details
- Comprehensive coin statistics
- Price charts
- Market data
- Historical performance

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

## Installation

1. Clone the repository
2. Open `Crypto_SwiftUI.xcodeproj` in Xcode
3. Build and run the project

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Author

Created by Danis Preldzic

---

Made with ❤️ using SwiftUI