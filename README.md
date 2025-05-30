# TN P2P - Tunisia's Trusted USDT Exchange

A non-custodial, privacy-first P2P exchange for Tunisian users to trade USDT (TRC20/ERC20) against TND via Flouci and D17 payment methods.

## Features

- 🔒 Non-custodial trading with multisig escrow
- 🇹🇳 Tunisia-optimized UI in Arabic, French, and English
- 💸 Flouci (RIB) and D17 payment methods
- 📱 Phone verification for Tunisian numbers
- ⚡ Real-time USDT/TND price updates
- 🛡️ Secure dispute resolution system

## Tech Stack

- **Frontend**: Next.js 14, TypeScript, Material-UI
- **Backend**: tRPC, Prisma, PostgreSQL
- **Blockchain**: USDT Smart Contracts (TRC20/ERC20)
- **Authentication**: Phone verification, 2FA
- **Localization**: i18next for Arabic/French/English

## Getting Started

### Prerequisites

- Node.js 18+
- PostgreSQL 14+
- Yarn or npm

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/tn-p2p.git
cd tn-p2p
```

2. Install dependencies:
```bash
npm install
```

3. Create a `.env` file:
```env
DATABASE_URL="postgresql://user:password@localhost:5432/tn_p2p"
NEXT_PUBLIC_TRON_NETWORK="mainnet"
NEXT_PUBLIC_ETH_NETWORK="mainnet"
PLATFORM_WALLET_ADDRESS="your_platform_wallet"
```

4. Initialize the database:
```bash
npx prisma migrate dev
```

5. Start the development server:
```bash
npm run dev
```

The application will be available at `http://localhost:3000`.

## Development

### Database Migrations

To create a new migration after modifying the schema:

```bash
npx prisma migrate dev --name your_migration_name
```

### Translations

Add new translations to the respective language files in `src/i18n.ts`.

### Smart Contracts

The escrow smart contracts are based on 2-of-3 multisig for both TRC20 and ERC20 USDT. Contract addresses:

- TRC20 Escrow: `[Contract Address]`
- ERC20 Escrow: `[Contract Address]`

## Security

- All private keys are generated client-side
- Escrow uses 2-of-3 multisig (buyer, seller, platform)
- Phone verification required for all users
- Optional KYC for higher limits
- Rate limiting and fraud detection

## Contributing

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/my-feature`
3. Commit your changes: `git commit -am 'Add new feature'`
4. Push to the branch: `git push origin feature/my-feature`
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support, email support@tnp2p.com or join our Telegram group. 