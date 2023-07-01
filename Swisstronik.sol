---
import { SITE } from '~/config.mjs';
import { getCanonical, getHomePermalink } from '~/utils/permalinks';
import Layout from '~/layouts/PageLayout.astro';
import { Icon } from 'astro-icon';

const name= 'Empower';
const icon= 'empower';
const network= 'mainnet';
const chain= 'empowerchain-1';
const version= 'v1.0.0';
const stake= 'https://explorer.sychonix.me/empower-mainnet/staking/empowervaloper1n9yenan0nuxrqfy85pyrg5qatuwcnrawtt0tcw';
const meta = {
	title: SITE.title,
	description: SITE.description,
	canonical: getCanonical(getHomePermalink()),
 };

const items = [
	{
		title: 'Explorer',
		Link: 'https://explorer.sychonix.me/empower-mainnet',
	},
	{
		title: 'Node installation',
		Link: 'https://service.sychonix.me/mainnet/empower/installation',
	},
  {
		title: 'Genesis file',
		Link: 'https://service.sychonix.me/mainnet/empower/genesis',
	},
{
		title: 'Peers',
		Link: 'https://service.sychonix.me/mainnet/empower/peers',
	},
  {
		title: 'Addrbook',
		Link: 'https://service.sychonix.me/mainnet/empower/addrbook',
	},
	{
		title: 'CLI Cheatsheet',
		Link: 'https://service.sychonix.me/mainnet/empower/cheat',
	},
]	
---

<Layout {meta}>
	<section>
		<div class="max-w-6xl mx-auto px-4 sm:px-6">
			<div class="py-10 md:py-20">
				<div class="text-center pb-5 md:pb-5 max-w-5xl mx-auto">
					<Icon name={icon} class="w-20 h-20 inline-block align-text-bottom" />           
					<h1 class="text-5xl md:text-[3.50rem] font-bold leading-tighter tracking-tighter mb-4 font-heading">
						Service {name}
					</h1>
					<a
							class="btn bg-primary-400 w-1/4 items-center hover:bg-primary-400 font-bold md:pb-4"
							href={stake}>Stake with me</a>
				</div>
				<section class="bg-primary-100 dark:bg-slate-800 items-center">
					<div class=" bg-transparent px-4 sm:px-6 py-4 text-md text-center font-medium">
							<li>
								<span class="font-bold">Network Type:</span> {network}							
							</li>
							<li>
								<span class="font-bold">Chain-id:</span> {chain}							
							</li>
							<li>
								<span class="font-bold">Node version:</span> {version}
							</li>
					</div>
				</section>
				<div class="grid gap-6 md:grid-cols-2 lg:grid-cols-3 items-start my-10 dark:text-white">
					{
						items.map(({ title , Link }) => (
						<a href={Link} target="_blank">  
							<div class="relative flex flex-col p-6 bg-white dark:bg-slate-900 rounded shadow-xl hover:shadow-lg transition dark:border dark:border-slate-800">
								<div class="flex items-center mb-4 text-center">					                   
									<div class="ml-4 text-xl font-bold text-center">{title}</div>                                 
								</div>
							</div>
						</a>  
						))
					}
				</div>
			</div>
		</div>
	</section>
	</Layout>
